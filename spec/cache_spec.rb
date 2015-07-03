require 'rspec'
require 'simple_cache'

module LinguineRack
  describe SimpleCache do

    subject { described_class.new }
    let (:key) { '/test' }
    let (:locale) { 'es' }
    let (:item) { 'Some testing text to put into the cache' }

    it 'adds to the cache' do
      expect(subject.get_cached_item(key, locale)).to be(nil)
      subject.add(key, locale, item)
      expect(subject.get_cached_item(key, locale)).to eq(item)
    end

    it 'removes from the cache' do
      subject.add(key, locale, item)
      expect(subject.get_cached_item(key, locale)).to eq(item)
      subject.remove(key, locale)
      expect(subject.get_cached_item(key, locale)).to be(nil)
    end

    it 'adds to the cache and overwrites previous content' do
      new_item = 'This is a new item that should overwrite the previous item'
      subject.add(key, locale, item)
      expect(subject.get_cached_item(key, locale)).to eq(item)
      subject.add(key, locale, new_item)
      expect(subject.get_cached_item(key, locale)).to eq(new_item)

    end

    it 'checks if a key has a cached item' do
      expect(subject.is_cached?(key, locale)).to be(false)
      subject.add(key, locale, item)
      expect(subject.is_cached?(key, locale)).to be(true)
    end

    it 'retrieves an item from the cache' do
      subject.add(key, locale, item)
      expect(subject.get_cached_item(key, locale)).to eq(item)
    end
  end
end