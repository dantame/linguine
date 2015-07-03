require_relative 'lib/simple_cache'
require 'rack/response'
require 'rack'

class Linguine

  attr_reader :app, :translator, :cache

  def initialize(app = nil, translator = nil, cache = LinguineRack::SimpleCache.new)
    if translator.nil?
      if ENV['RACK_ENV'] == 'production'
        client_id = ENV['LINGUINE_BING_CLIENT_ID']
        client_secret = ENV['LINGUINE_BING_CLIENT_SECRET']
        if !client_id || !client_secret
          raise ArgumentError, 'Missing Bing Client Id or Client Secret'
        end
        @translator = LinguineRack::Translator::Bing.new client_id, client_secret
      else
        @translator = LinguineRack::Translator::Google.new
      end
    end
    @app = app
    @cache = cache
  end

  def parse res, env
    path = env['PATH_INFO']
    parsed_path, locale = split_path path
    if @cache.is_cached?(parsed_path, locale)
      puts "HIT CACHE FOR #{path}"
      @cache.get_cached_item(parsed_path, locale)
    elsif locale
      puts "HIT TRANSLATE FOR #{path}"
      response = translate_response res, locale
      @cache.add(parsed_path, locale, response)
      response
    else
      res
    end
  end

  def translate_response res, locale
    response = Rack::Response.new
    parsed_html = Nokogiri::HTML(res.body.clone.join)
    parsed_html.traverse do |el|
      if el.text?
        el.content = @translator.translate(el.content, locale)
      end
    end

    response.write parsed_html.to_s
    response
  end

  def split_path path
    pattern = /(.+)\.(\w+)$/
    _, path, locale = pattern.match(path).to_a
    return path, locale
  end

  def call env
    if app.nil?
      status, headers, res = get_response env
    else
      status, headers, res = @app.call(env)
    end
    response = parse(res, env)
    response.finish
  end

end