require 'google_translate'
require 'google_translate/result_parser'

module LinguineRack
  module Translator
    class Google

      def initialize
        @translator = GoogleTranslate.new
      end

      def translate text, to, from = 'en'
        result = @translator.translate(from, to, text)
        parser = ResultParser.new result
        parser.translation
      end

    end
  end
end