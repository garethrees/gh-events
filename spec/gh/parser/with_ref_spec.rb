RSpec.describe GH::Parser::WithRef do
  describe '#[]' do
    subject { described_class.new(hash)[key] }

    context 'ref key' do
      let(:key) { 'ref' }

      context 'when there is a ref' do
        let(:hash) { { 'ref' => 'refs/heads/foo' } }
        it { is_expected.to eq('foo') }
      end

      context 'when there is no ref' do
        let(:hash) { { 'foo' => 'bar' } }
        it { is_expected.to be_nil }
      end
    end

    context 'ref_type key' do
      let(:key) { 'ref_type' }

      context 'when the ref is a branch' do
        let(:hash) { { 'ref' => 'refs/heads/foo' } }
        it { is_expected.to eq('branch') }
      end

      context 'when the ref is a tag' do
        let(:hash) { { 'ref' => 'refs/tags/v1.0.0' } }
        it { is_expected.to eq('tag') }
      end

      context 'when there is no ref' do
        let(:hash) { { 'foo' => 'bar' } }
        it { is_expected.to be_nil }
      end
    end
  end
 end
