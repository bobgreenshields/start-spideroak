require_relative "../logging"

module Tmux
	class Session
		include Logging

		attr_accessor :name

		@@session_regex = /^(?<sessionname>\S+):.*$/

		def initialize(session_string)
			logger.debug { "looking for a session called #{session_string}" }
			match = @@session_regex.match(session_string)
			if match
				logger.debug { "session called #{session_string} has been found" }
				@name = match[:sessionname]
			else
				logger.fatal { "session called #{session_string} could not be found" }
				raise ArgumentError, "badly formatted session string: #{session_string}"	
			end
		end

		def name?(value)
			@name == value	
		end
		
	end
end
