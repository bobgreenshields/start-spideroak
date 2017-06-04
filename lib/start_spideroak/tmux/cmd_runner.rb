require "open3"

module StartSpideroak
	class Tmux
		class CmdRunner

			attr_reader :s_out, :s_err, :exit_code

			def call(command_string)
				@s_out, @s_err, exit_status = Open3.capture3(command_string)
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
end