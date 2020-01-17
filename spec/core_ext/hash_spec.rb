RSpec.describe Hash do
  describe '#deep_stringify_keys' do
    subject { hash.deep_stringify_keys }
    let(:hash) { { foo: { bar: 'baz' } } }
    it { is_expected.to eq('foo' => { 'bar' => 'baz' }) }
  end
end
