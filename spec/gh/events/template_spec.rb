RSpec.describe GH::Events::Template do
  describe '.for_event' do
    subject { described_class.for_event(event, dict: dict) }

    context 'with the default dict' do
      let(:event) { double(aspects: %w[issues opened]) }
      let(:dict) { nil }

      let(:templates) do
        YAML.load_file(File.expand_path(File.join(%w[res plain.yml])))
      end

      it { is_expected.to eq(described_class.new(templates['issues.opened'])) }
    end

    context 'with a packaged dict' do
      let(:event) { double(aspects: %w[issues opened]) }
      let(:dict) { 'slack' }

      let(:templates) do
        YAML.load_file(File.expand_path(File.join(%w[res slack.yml])))
      end

      it { is_expected.to eq(described_class.new(templates['issues.opened'])) }
    end

    context 'with a custom dict' do
      let(:event) { double(aspects: %w[issues opened]) }

      # Directly pass a full path to a dict file, rather the name, to simulate a
      # file being passed from the CLI
      let(:dict) { File.expand_path(File.join(%w[res slack.yml])) }
      let(:templates) { YAML.load_file(dict) }

      it { is_expected.to eq(described_class.new(templates['issues.opened'])) }
    end

    context 'with an unknown dict' do
      let(:event) { double(aspects: %w[issues opened]) }
      let(:dict) { 'error' }

      it 'raises UnknownDictFileError' do
        expect { subject }.to raise_error(described_class::UnknownDictFileError)
      end
    end
  end

  describe '#render' do
    subject { described_class.new(template_data).render(event) }

    context 'with a String template' do
      let(:template_data) { %q[<%= repository.full_name %>] }
      let(:event) { OpenStruct.new(repository: double(full_name: 'foo/bar')) }

      it { is_expected.to eq(%q["foo/bar"]) }
    end

    context 'with a Hash template' do
      let(:template_data) do
        { 'text' => %q[<%= repository.full_name %>],
          'attachments' => [ 'foo' => 'bar'] }
      end

      let(:event) { OpenStruct.new(repository: double(full_name: 'foo/bar')) }
      let(:expected) { %q[{"text":"foo/bar","attachments":[{"foo":"bar"}]}] }

      it { is_expected.to eq(expected) }
    end
  end

  describe '#==' do
    let(:a) { described_class.new('template_a') }
    let(:b) { described_class.new('template_a') }
    let(:c) { described_class.new('template_b') }

    it 'is equal when the object is the same' do
      expect(a).to eq(a)
    end

    it 'is equal when the encapsulated template is the same' do
      expect(a).to eq(b)
    end

    it 'is not equal when the encapsulated template differs' do
      expect(a).not_to eq(c)
    end
  end
end
