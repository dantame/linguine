require 'rspec'
require 'support/translator_example'
require 'translator/bing'

module LinguineRack
  module Translator
    describe Bing do
      subject { described_class.new 'linguine', '88t/KdxyT8xOyCsylmywine/D5YWm71SZTm3UnjY/x4=' }
      it_behaves_like 'translator'
    end
  end
end