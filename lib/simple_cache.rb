module LinguineRack
  class SimpleCache

    def initialize cache = {}
      @cache = cache
    end

    def add key, locale, item
      @cache[key] = {} if @cache[key].nil?
      @cache[key][locale] = item
    end

    def remove key, locale
      unless @cache[key].nil?
        @cache[key][locale] = nil
      end
    end

    def is_cached? key, locale
      !@cache[key].nil? && !@cache[key][locale].nil?
    end

    def get_cached_item key, locale
      return nil if @cache[key].nil?
      @cache[key][locale]
    end
  end
end