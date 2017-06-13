module StartSpideroak
	class Tmux
		class NullLogger
			def unknown(*); end
			def debug(*); end
			def info(*); end
			def warn(*); end
			def error(*); end
			def fatal(*); end
		end
	end
end
