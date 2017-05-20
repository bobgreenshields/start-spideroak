module StartSpideroak
	class Tmux
		class Session

			attr_accessor :name

			@@session_regex = /^(?<sessionname>\S+):.*$/

			def initialize(session_string)
				match = @@session_regex.match(session_string)
				if match
					@name = match[:sessionname]
				else
					raise ArgumentError, "badly formatted session string: #{session_string}"	
				end
			end
			
		end
	end
end
