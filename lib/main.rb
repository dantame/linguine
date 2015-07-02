require_relative 'simple_cache'

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
        response = @translator.translate(res[0], locale)
        @cache.add(parsed_path, locale, response)
        return [response]
      else
        res
      end
    end

    def split_path path
      pattern = /(.+)\.(\w+)$/
      _, path, locale = pattern.match(path).to_a
      return path, locale
    end
  end
end