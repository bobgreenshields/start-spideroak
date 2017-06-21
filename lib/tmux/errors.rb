module Tmux
	
	class TmuxError < RuntimeError
	end

	class TmuxSessionCreateFailedError < TmuxError
	end

end
