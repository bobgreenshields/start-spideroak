require_relative "../logging"

module Tmux
	class Session
		include Logging

		attr_accessor :name

		@@session_regex = /^(?<sessionname>\S+):.*$/

		def initialize(session_string)
			logger.debug { "Session#initialize trying to match a session name in #{session_string}" }
			match = @@session_regex.match(session_string)
			if match
				logger.debug { "Session#initialize successfully matched #{match[:sessionname]}" }
				@name = match[:sessionname]
			else
				logger.fatal { "Session#initialize could not match a session name in #{session_string}" }
				raise ArgumentError, "badly formatted session string: #{session_string}"	
			end
		end

		def name?(value)
			@name == value	
		end
		
	end
end
