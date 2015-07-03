require_relative 'simple_cache'
require 'rack/response'

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
        @cache.get_cached_item(parsed_path, locale)
      elsif locale
        response = Rack::Response.new
        body = translate_response res
        response.write body
        @cache.add(parsed_path, locale, response)
        response
      else
        res
      end
    end

    def translate_response res
      parsed_html = Nokogiri::HTML(res.body.clone.join)
      parsed_html.traverse do |item|
        if item.text?
          item.content = @translator.translate(item.content, locale)
        end
      end
      parsed_html.to_s
    end

    def split_path path
      pattern = /(.+)\.(\w+)$/
      _, path, locale = pattern.match(path).to_a
      return path, locale
    end
  end
end