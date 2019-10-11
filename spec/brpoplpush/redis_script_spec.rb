# frozen_string_literal: true

RSpec.describe Brpoplpush::RedisScript do
  subject { described_class }

  it "has a version number" do
    expect(Brpoplpush::RedisScript::VERSION).not_to be nil
  end

  it { is_expected.to respond_to(:execute).with(2).arguments.and_keywords(:keys, :argv) }
end
