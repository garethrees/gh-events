RSpec.describe GH::Events::Text do
  describe '.translate' do
    path = File.expand_path(File.join(%w(.. .. .. fixtures)), __FILE__)

    Dir.glob('*.json', base: path).sort.each do |file|
      name = File.basename(file, '.json')

      it "renders events of type #{name}" do
        event = File.read(File.join(path, file))
        expect { GH::Events::Text.translate(event, nil) }.to_not raise_error
      end
    end

    # TODO write a similar spec for `slack.yml` and validate the output
    # with a simple json schema for slack messages
  end

  describe '#render' do
    let(:event) { double }
    let(:template) { double(render: 'foo') }

    it 'renders the template for the event' do
      expect(template).to receive(:render).with(event)
      expect(described_class.new(event, template).render).to eq('foo')
    end

    it 'returns nil if the template is nil' do
      expect(described_class.new(event, nil).render).to be_nil
    end
  end

  describe '#==' do
    subject { a == b }

    let(:a) { described_class.new(double, template_a) }
    let(:b) { described_class.new(double, template_b) }

    context 'when the render output is identical' do
      let(:template_a) { double(render: 'foo') }
      let(:template_b) { double(render: 'foo') }
      it { is_expected.to eq(true) }
    end

    context 'when the render output is different' do
      let(:template_a) { double(render: 'foo') }
      let(:template_b) { double(render: 'bar') }
      it { is_expected.to eq(false) }
    end
  end
end
