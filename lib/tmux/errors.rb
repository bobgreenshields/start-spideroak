module Tmux
	
	class TmuxError < RuntimeError
	end

	class TmuxSessionCreateFailedError < TmuxError
	end

	class TmuxExecutableNotInstalledError < TmuxError
	end

end
