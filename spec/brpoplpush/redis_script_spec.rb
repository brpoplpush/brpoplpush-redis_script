# frozen_string_literal: true

RSpec.describe Brpoplpush::RedisScript do
  subject { described_class }

  describe ".execute" do
    it { is_expected.to respond_to(:execute).with(2).arguments.and_keywords(:keys, :argv) }
  end

  describe ".version" do
    subject(:version) { described_class.version }

    it { is_expected.to eq(Brpoplpush::RedisScript::VERSION) }
  end

  describe ".logger" do
    subject(:logger) { described_class.logger }

    it { is_expected.to be_a(Logger) }
  end

  describe ".logger=" do
    subject(:set_logger) { described_class.logger = logger }

    let(:logger) { Logger.new($stdout) }

    it "delegates to config.logger = ?" do
      allow(described_class.config).to receive(:logger=)

      set_logger

      expect(described_class.config).to have_received(:logger=).with(logger)
    end
  end
end
