require_relative 'simple_cache'
require 'rack/response'
require 'rack'

module Linguine
  class Main

    attr_reader :translator, :cache

    def initialize translator, cache = SimpleCache.new
      @translator = translator
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
  end
end