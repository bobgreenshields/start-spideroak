require_relative "../logging"
require_relative "cmd_runner"
require_relative "sessions"
#require_relative "errors"

module Tmux
	class App
		def initialize(cmd_runner = nil)
			@cmd_runner = cmd_runner || Tmux::CmdRunner.new
			@sessions = Tmux::Sessions.new(@cmd_runner)
		end

		def include_session?(session_name)
			@sessions.include? session_name
		end
		
	end
end
