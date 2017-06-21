require "start_spideroak/tmux/app"

describe Tmux::App do
	describe "#include_session?" do
		context "when no sessions present" do
			let (:cmd_mock) { CmdRunnerMock.failure("failed to connect to server: Connection refused\n", occurs: 2) }
			let (:app) { Tmux::App.new(cmd_mock) }

			it "returns false" do
				expect(app.include_session?("unknown_session_name")).to be_falsey
			end
		end
	end
	
end
