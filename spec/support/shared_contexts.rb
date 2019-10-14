# frozen_string_literal: true

RSpec.shared_context "with test config" do
  let(:config)       { Brpoplpush::RedisScript::Config.new }
  let(:scripts_path) { SCRIPTS_PATH }

  before do
    config.scripts_path = scripts_path
  end
end
