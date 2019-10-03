# frozen_string_literal: true

RSpec.describe Brpoplpush::RedisScript::Client do
  subject { described_class }

  it { is_expected.to respond_to(:call).with(2).arguments.and_keywords(:keys, :argv) }
  it { is_expected.to respond_to(:script_source).with(1).arguments }
  it { is_expected.to respond_to(:script_path).with(1).arguments }

  describe ".call" do
    subject(:call) { described_class.call(script_name, redis, script_arguments) }

    let(:keys)             { %w[key_one key_two key_tre key_for key_fav] }
    let(:argv)             { %w[arg_one arg_two arg_tre arg_for arg_fav] }
    let(:redis)            { Redis.new }
    let(:scriptsha)        { "abcdefab" }
    let(:script_arguments) { { keys: keys, argv: argv } }
    let(:script_name)      { :test }
    let(:exception)        { nil }

    before do
      call_count = 0
      allow(described_class).to receive(:execute_script).with(script_name, redis, keys, argv) do
        call_count += 1
        (call_count == 1) ? raise(Redis::CommandError, error_message) : 1
      end

      allow(described_class::SCRIPT_SHAS).to receive(:delete)

      exception
    end

    context "when error starts with ERR" do
      let(:error_message) do
        <<~ERR
          ERR Error running script (call to f_178d75adaa46af3d8237cfd067c9fdff7b9d504f): [string "func definition"]:7: attempt to compare nil with number
        ERR
      end

      let(:script_error_message) do
        <<~ERR_MSG
          attempt to compare nil with number

              5: local key_fiv = KEYS[5]
              6: local arg_one = ARGV[1]
           => 7: local arg_two = ARGV[2]
              8: local arg_tre = ARGV[3]
              9: local arg_for = ARGV[4]

        ERR_MSG
      end

      let(:exception) do
        call
      rescue Brpoplpush::RedisScript::Error => ex
        ex
      end

      specify { expect(exception.message).to eq(script_error_message) }
      specify { expect(exception.backtrace.first).to match(%r{spec/support/lua/test.lua:7}) }
      specify { expect(exception.backtrace[1]).to match(/client.rb/) }
      specify { expect(described_class::SCRIPT_SHAS).not_to have_received(:delete).with(script_name) }
      specify { expect(described_class).to have_received(:execute_script).with(script_name, redis, keys, argv).once }
    end

    context "when error starts with BUSY" do
      let(:error_message) { "BUSY Redis is busy running a script. You can only call SCRIPT KILL or SHUTDOWN NOSAVE." }

      before do
        allow(Redis).to receive(:new).and_return(redis)
      end

      context "when .script(:kill) raises CommandError" do
        before do
          allow(redis).to receive(:script).with(:kill) { raise Redis::CommandError, "NOT BUSY" }
          allow(described_class).to receive(:log_warn)
        end

        specify do
          expect { call }.not_to raise_error
          expect(described_class).to have_received(:log_warn).with(kind_of(Redis::CommandError))
          expect(described_class).to have_received(:execute_script).with(script_name, redis, keys, argv).twice
        end
      end

      context "when .script(:kill) is successful" do
        before { allow(redis).to receive(:script).with(:kill).and_return(true) }

        specify do
          expect { call }.not_to raise_error

          expect(redis).to have_received(:script).with(:kill)
          expect(described_class).to have_received(:execute_script).with(script_name, redis, keys, argv).twice
        end
      end
    end

    context "when error starts with NOSCRIPT" do
      let(:error_message) { "NOSCRIPT No matching script. Please use EVAL." }

      specify do
        expect { call }.not_to raise_error

        expect(described_class::SCRIPT_SHAS).to have_received(:delete).with(script_name)
        expect(described_class).to have_received(:execute_script).with(script_name, redis, keys, argv).twice
      end
    end
  end
end
