require 'rspec'

shared_context 'translator' do
  let (:res) { "Now that we know who you are, I know who I am, I'm not a mistake!" }
  let (:res_es) { 'Ahora que sabemos quién eres, sé quien soy, no soy un error!' }
  let (:locale) { 'es' }

  it 'translates the text given to spanish' do
    expect(subject.translate(res, locale)).to eq(res_es)
  end
end