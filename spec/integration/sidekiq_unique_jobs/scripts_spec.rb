# frozen_string_literal: true

require_relative "scripts"

RSpec.describe SidekiqUniqueJobs::Scripts do
  describe ".execute" do
    subject(:execute) { described_class.execute(script_name, script_conn, script_args) }

    let(:script_name) { :lock }
    let(:script_conn) { Redis.new }
    let(:script_args) { { keys: script_keys, argv: script_argv } }
    let(:script_keys) { [key_one, key_two] }
    let(:script_argv) { [lock_value] }
    let(:key_one)     { "abcdefab" }
    let(:lock_value)  { ["abv"] }

    context "when key one and two matches" do
      let(:key_two) { "abcdefab" }

      it { is_expected.to eq(-1) }
    end

    context "when key one and two differs" do
      let(:key_two) { "cdeflkjh" }

      it { is_expected.to eq(1) }

      context "when key was already set" do
        before do
          described_class.execute(script_name, script_conn, script_args)
        end

        it { is_expected.to be_nil }
      end
    end
  end
end
