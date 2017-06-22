require "logger"
require "pathname"
require_relative "logging"
require_relative "tmux/app"

CODE_LOG_DIR_DOES_NOT_EXIST = 11
CODE_CANNOT_WRITE_TO_LOG_DIR = 12

LOG_DIR = '/var/log/spideroak'
LOG_FILE_NAME = 'spideroak.log'
LOGGER = Logger.new(STDOUT)
LOG_LEVEL = Logger::DEBUG

#SPIDEROAK_TMUX_SESSION_NAME = "spideroak"
SPIDEROAK_TMUX_SESSION_NAME = "test"
START_SPIDEROAK_COMMAND = '"ls -al" C-m'

def exit_unless_log_dir_exists
	unless Dir.exist?(LOG_DIR)
		STDERR.puts "FATAL ERROR: the log dir: #{LOG_DIR} does not exist"
		exit(CODE_LOG_DIR_DOES_NOT_EXIST)
	end
end

def exit_if_cannot_write_to_log_dir
	unless can_write_to_dir?(LOG_DIR)
		STDERR.puts "FATAL ERROR: cannot write to the log dir: #{LOG_DIR}\n"\
			"check the directory permissions"
		exit(CODE_CANNOT_WRITE_TO_LOG_DIR)
	end
end

def can_write_to_dir?(dir_name)
	return false unless Dir.exist?(dir_name)
  test_file_path = Pathname.new(dir_name) + Time.new.strftime("%Y%m%d%H%m%S.test")
	begin
		File.open(test_file_path, "w") {}
		true
	rescue Errno::EACCES
		false
	ensure
		File.delete(test_file_path) if File.exist?(test_file_path)
	end
end

def tmux
	@tmux ||= Tmux::App.new
end

def stop_spideroak
	tmux.send_keys_to_session(keys: "C-c", session: SPIDEROAK_TMUX_SESSION_NAME)
end

def wait_a_second
	sleep(1)
end

def set_up_logging
	#Logging.logger = Logger.new(STDOUT)
	#Logging.logger.level = Logger::DEBUG
	Logging.logger = LOGGER
	Logging.logger.level = LOG_LEVEL
	Logging.logger.debug { "logger set up" }
end

def start_spideroak
	tmux.send_keys_to_session(keys: START_SPIDEROAK_COMMAND,
		session: SPIDEROAK_TMUX_SESSION_NAME)
end

def log_error(raised_error)
	Logging.logger.fatal(
		"\n\n#{raised_error.class} (#{raised_error.message}):\n    " +
		raised_error.backtrace.join("\n    ") +
		"\n\n")
end

exit_unless_log_dir_exists
exit_if_cannot_write_to_log_dir
set_up_logging
begin
	stop_spideroak
	wait_a_second
	start_spideroak
rescue StandardError => e
	log_error(e)
	raise e
end
exit(0)
