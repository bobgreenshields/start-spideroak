require "open3"

module Tmux
	class CmdRunner

		attr_reader :command_string, :std_out, :std_err, :exit_code

		def call(command_string)
			@command_string = command_string
			@std_out, @std_err, exit_status = Open3.capture3(command_string)
			@exit_code = exit_status.to_i
		end

		def success?
			@exit_code == 0
			end

		def on_success
			yield self if success?
		end

		def on_failure
			yield self if ! success?
		end
	end
end
