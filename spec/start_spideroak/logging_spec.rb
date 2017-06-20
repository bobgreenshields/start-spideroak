require "start_spideroak/logging"

class LogTest
	include Logging

	def info
		logger.info "test"
	end
end


describe "Logging" do
	context "when included into a class" do
		it "the class should respond to #logger" do
			expect(LogTest.new).to respond_to :logger
		end
	end

	context "when a logger is set on the Logging module" do
		it "instances should send messages to that logger" do
			log_dbl = double("logger")
			expect(log_dbl).to receive :info
			Logging.logger = log_dbl
			LogTest.new.info
		end
	end

	
end
