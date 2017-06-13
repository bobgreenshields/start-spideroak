require_relative "cmd_runner"
require_relative "session"

module Tmux

	class TmuxError < RuntimeError
	end

	class TmuxSessionCreateFailedError < TmuxError
	end

	class Sessions

		SESSIONS_CMD = 'tmux list-sessions'

		def initialize(cmd_runner = nil)
			@cmd_runner = cmd_runner || Tmux::CmdRunner.new
			load_sessions
		end

		def load_sessions
			@cmd_runner.call SESSIONS_CMD
			@cmd_runner.on_failure { @sessions = [] }
			@cmd_runner.on_success \
				{ | cmd_runner | build_sessions_from_string(cmd_runner.std_out) }
		end

		def build_sessions_from_string(sessions_string)
			@sessions = sessions_string.split("\n").
				map { | session_string | Tmux::Session.new(session_string) }
		end

		def include?(session_name)
			@sessions.any? { | session | session.name?(session_name) }
		end

		def create(session_name)
			return if include?(session_name)
			@cmd_runner.call("tmux new-session -d -s #{session_name}")
			@cmd_runner.on_failure { raise TmuxSessionCreateFailedError,
				"Tmux::Sessions#create failed to create a session called #{session_name}" }
			@cmd_runner.on_success { check_new_session_exists(session_name) }
		end

		def check_new_session_exists(session_name)
			load_sessions
			unless include?(session_name)
				raise TmuxSessionCreateFailedError,
					"Tmux::Session::Create seemed to succeed " \
					"but a session called #{session_name} could not be found"
			end
		end
	end
end
