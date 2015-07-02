require 'rspec'
require 'support/translator_example'
require 'translator/google'

module Linguine
  module Translator
    describe Google do
      subject { described_class.new }
      it_behaves_like 'translator'
    end
  end
end