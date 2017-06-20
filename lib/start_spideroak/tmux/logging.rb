module Tmux
	module Logging
		class NullLogger
			def unknown(*); end
			def debug(*); end
			def info(*); end
			def warn(*); end
			def error(*); end
			def fatal(*); end
		end

		class << self
			attr_writer :logger

			def logger
				@logger ||= NullLogger.new
			end
		end
	end
end
