require "tmux/app"

describe Tmux::App do
	describe "#include_session?" do
		context "when no sessions present" do
			#let (:cmd_mock) { CmdRunnerMock.failure("failed to connect to server: Connection refused\n", occurs: 2) }
			let (:cmd_mock) { CmdRunnerMock.new([
				{std_out: '/usr/bin/tmux', std_err: "", exit_code: 0},
				{std_out: "", std_err: "failed to connect to server: Connection refused\n", exit_code: 1},
				{std_out: "", std_err: "failed to connect to server: Connection refused\n", exit_code: 1}
				]) }
			let (:app) { Tmux::App.new(cmd_mock) }

			it "returns false" do
				expect(app.include_session?("unknown_session_name")).to be_falsey
			end
		end

		context "when named session is present" do
			#let (:cmd_mock) { CmdRunnerMock.success("guake: 1 windows\nnext: 2 windows", occurs: 2) }
			let (:cmd_mock) { CmdRunnerMock.new([
				{std_out: '/usr/bin/tmux', std_err: "", exit_code: 0},
				{std_out: "guake: 1 windows\nnext: 2 windows", std_err: "", exit_code: 0},
				{std_out: "guake: 1 windows\nnext: 2 windows", std_err: "", exit_code: 0}
				]) }
			let (:app) { Tmux::App.new(cmd_mock) }

			it "returns true" do
					expect(app.include_session?("guake")).to be_truthy
			end
		end

		context "when named session is not present" do
			#let (:cmd_mock) { CmdRunnerMock.success("guake: 1 windows\nnext: 2 windows", occurs: 2) }
			let (:cmd_mock) { CmdRunnerMock.new([
				{std_out: '/usr/bin/tmux', std_err: "", exit_code: 0},
				{std_out: "guake: 1 windows\nnext: 2 windows", std_err: "", exit_code: 0},
				{std_out: "guake: 1 windows\nnext: 2 windows", std_err: "", exit_code: 0}
				]) }
			let (:app) { Tmux::App.new(cmd_mock) }

			it "returns false" do
				expect(app.include_session?("unknown_session_name")).to be_falsey
			end
		end
	end

	describe "#new" do
		context "when tmux is not installed" do
			let (:cmd_mock) { CmdRunnerMock.new([
				{std_out: "", std_err: "tmux not found", exit_code: 1}
				]) }

			it "raises an error" do
				expect { Tmux::App.new(cmd_mock) }.to raise_error(Tmux::TmuxExecutableNotInstalledError)
			end
		end

		context "when tmux is installed" do
			before :example do
				@cmd_mock = CmdRunnerMock.new([
					{std_out: '/usr/bin/tmux', std_err: "", exit_code: 0},
					{std_out: "guake: 1 windows\nnext: 2 windows", std_err: "", exit_code: 0}
					])
			end

			it "does not raise an error" do
				expect { Tmux::App.new(@cmd_mock) }.not_to raise_error
			end

		end
		
	end

	describe "#send_keys_to_session" do
		context "when the named session does not exist" do

			it "creates the session and sends the keys" do
				cmd_spy = spy('cmd')
				cmd_mock = CmdRunnerMock.new([
				{std_out: '/usr/bin/tmux', std_err: "", exit_code: 0},
				{std_out: "guake: 1 windows\nnext: 2 windows", std_err: "", exit_code: 0},
				{std_out: "guake: 1 windows\nnext: 2 windows", std_err: "", exit_code: 0},
				{std_out: "", std_err: "", exit_code: 0},
				{std_out: "guake: 1 windows\nnext: 2 windows\ntest: 1 windows", std_err: "", exit_code: 0},
				{std_out: "", std_err: "", exit_code: 0}
				], cmd_spy: cmd_spy)
				app = Tmux::App.new(cmd_mock)
				app.send_keys_to_session(keys: '"command string" C-m', session: "test")
				expect(cmd_spy).to have_received(:call).with("tmux new-session -d -s test")
				expect(cmd_spy).to have_received(:call).with('tmux send-keys -t test "command string" C-m')
			end
		end
	end
	
end
