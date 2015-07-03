require 'rspec'
require 'support/translator_example'
require 'translator/google'

module LinguineRack
  module Translator
    describe Google do
      subject { described_class.new }
      it_behaves_like 'translator'
    end
  end
end