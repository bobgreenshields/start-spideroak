require_relative "../logging"
require_relative "cmd_runner"
require_relative "sessions"
require_relative "errors"

module Tmux
	class App
		def initialize(cmd_runner = nil)
			@cmd_runner = cmd_runner || Tmux::CmdRunner.new
			check_tmux_installed
			@sessions = Tmux::Sessions.new(@cmd_runner)
		end

		def include_session?(session_name)
			@sessions.include? session_name
		end

		def send_keys_to_session(keys:, session:)
			@sessions.create(session)
			cmd_string = ["tmux send-keys -t", session, keys].join(' ')
			@cmd_runner.call cmd_string
		end

		def check_tmux_installed
			@cmd_runner.call "which tmux"
			@cmd_runner.on_failure do
				raise TmuxExecutableNotInstalledError, "tmux is not installed on this machine"
			end
		end
		
	end
end
