lib_dir = File.join(File.dirname(__FILE__), '../lib')
full_lib_dir = File.expand_path(lib_dir)
$LOAD_PATH.unshift(full_lib_dir) unless
	$LOAD_PATH.include?(lib_dir) || $LOAD_PATH.include?(full_lib_dir)

Dir["./spec/support/**/*.rb"].each { |f| require f }

#include StartSpideroak

class CmdRunnerMock

	def self.success(message, occurs: 1)
		arg_array = []
		occurs.times do
			arg_array << {std_out: message, std_err: "", exit_code: 0}
		end
		new(arg_array)
	end

	def self.failure(message, occurs: 1)
		arg_array = []
		occurs.times do
			arg_array << {std_out: "", std_err: message, exit_code: 1}
		end
		new(arg_array)
	end

	attr_reader :std_out, :std_err, :exit_code

	def initialize(arg_array)
		@reverse_arg_array = arg_array.reverse
	end

	def load_args(arg_hash)
		@std_out = arg_hash[:std_out]
		@std_err = arg_hash[:std_err]
		@exit_code = arg_hash[:exit_code]
	end

	def unexpected_call
		raise "the CmdRunnerMock was called unexpectedly"
	end

	def call(command)
		load_args(@reverse_arg_array.pop || unexpected_call)
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
