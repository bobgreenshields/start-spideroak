require "start_spideroak/tmux/sessions"

#include StartSpideroak

describe Tmux::Sessions do
	describe "#initialize" do
		context "when there are tmux sessions" do
			let (:cmd_mock) { CmdRunnerMock.success("guake: 1 windows\nnext: 2 windows") }
			let (:sessions) { Tmux::Sessions.new(cmd_mock) }

			it "returns a Tmux::sessions instance" do
				expect(sessions).to be_an_instance_of(Tmux::Sessions)
			end
		end

		context "when there are no tmux sessions" do
			let (:cmd_mock) { CmdRunnerMock.failure("failed to connect to server: Connection refused\n") }
			let (:sessions) { Tmux::Sessions.new(cmd_mock) }

			it "returns a Tmux::sessions instance" do
				expect(sessions).to be_an_instance_of(Tmux::Sessions)
			end
		end
	end

	describe "#include?" do
		context "when one of the tmux sessions has that name" do
			let (:cmd_mock) { CmdRunnerMock.success("guake: 1 windows\nnext: 2 windows") }
			let (:sessions) { Tmux::Sessions.new(cmd_mock) }

			it "returns true" do
				expect(sessions.include?("guake")).to be_truthy
			end
		end

		context "when none of the tmux sessions have that name" do
			let (:cmd_mock) { CmdRunnerMock.success("guake: 1 windows\nnext: 2 windows") }
			let (:sessions) { Tmux::Sessions.new(cmd_mock) }

			it "returns false" do
				expect(sessions.include?("unknown")).to be_falsey
			end
		end

		context "when there are no tmux sessions" do
			let (:cmd_mock) { CmdRunnerMock.failure("failed to connect to server: Connection refused\n") }
			let (:sessions) { Tmux::Sessions.new(cmd_mock) }

			it "returns false" do
				expect(sessions.include?("guake")).to be_falsey
			end
		end
	end

	describe "#create" do
		context "when the session already exists" do
			let (:cmd_mock) { CmdRunnerMock.success("guake: 1 windows\nnext: 2 windows") }
			let (:sessions) { Tmux::Sessions.new(cmd_mock) }

			it "does nothing" do
				expect { sessions.create("guake") }.not_to raise_error
			end
		end

		context "when session creation fails" do
			let (:cmd_mock) { CmdRunnerMock.new([
				{std_out: "guake: 1 windows", std_err: "", exit_code: 0},
				{std_out: "", std_err: "", exit_code: 5}
				]) }
			let (:sessions) { Tmux::Sessions.new(cmd_mock) }
			it "raises a TmuxSessionCreateFailedError" do
				expect { sessions.create("test") }.to raise_error(Tmux::TmuxSessionCreateFailedError)
			end
		end

		context "when session creation succeeds but the session cannot be found" do
			let (:cmd_mock) { CmdRunnerMock.new([
				{std_out: "guake: 1 windows", std_err: "", exit_code: 0},
				{std_out: "", std_err: "", exit_code: 0},
				{std_out: "guake: 1 windows", std_err: "", exit_code: 0}
				]) }
			let (:sessions) { Tmux::Sessions.new(cmd_mock) }
			it "raises a TmuxSessionCreateFailedError" do
				expect { sessions.create("test") }.to raise_error(Tmux::TmuxSessionCreateFailedError)
			end
		end

		context "when session creation works and the new session can be found" do
			let (:cmd_mock) { CmdRunnerMock.new([
				{std_out: "guake: 1 windows", std_err: "", exit_code: 0},
				{std_out: "", std_err: "", exit_code: 0},
				{std_out: "guake: 1 windows\ntest: 2 windows", std_err: "", exit_code: 0}
				]) }
			let (:sessions) { Tmux::Sessions.new(cmd_mock) }
			it "does not raise an error" do
				expect { sessions.create("test") }.not_to raise_error
			end
		end
	end
end
