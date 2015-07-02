require 'rspec'
require 'main'
require 'translator/google'

module Linguine
  describe Main do

    subject { described_class.new Translator::Google.new }
    let (:locale) { 'es' }
    let (:path) { '/this/is/a/test.es' }
    let (:res) { 'one' }
    let (:res_es) { 'uno' }
    let (:env) { {"PATH_INFO" => path } }

    it 'returns a response which hits the cache' do
      subject.parse(res, env)
      expect(subject.cache).to receive(:get_cached_item).once.and_return(res_es)
      expect(subject.parse(res, env)).to eq(res_es)
    end

    it 'returns a response which doesn\'t hit the cache' do
      expect(subject.translator).to receive(:translate).once.and_return(res_es)
      expect(subject.cache).to_not receive(:get_cached_item)
      expect(subject.parse(res, env)).to eq(res_es)
    end

    it 'derives the locale to use in translation from the path' do
      parsed_path = path.split('.')[0]
      expect(subject.split_path(path)).to eq([parsed_path, locale])
    end

  end
end