RSpec.describe GH::Parser::WithType do
  describe '#[]' do
    subject { described_class.new(hash)[key] }

    context 'type key' do
      let(:key) { 'type' }
      let(:hash) { { 'foo' => 'bar' } }
      it { is_expected.to eq('unknown') }
    end

    context 'aspects key' do
      let(:key) { 'aspects' }

      let(:hash) do
        { 'issue' => double, 'repository' => double, 'action' => 'opened' }
      end

      it { is_expected.to eq(%w[issues opened]) }
    end

    context 'stype key' do
      let(:key) { 'stype' }

      let(:hash) do
        { 'issue' => double, 'repository' => double, 'action' => 'opened' }
      end

      it { is_expected.to eq('issues.opened') }
    end
  end
end
