require "start_spideroak/tmux/session"

include StartSpideroak

describe Tmux::Session do
	describe "#initialize" do

		subject(:session) { Tmux::Session.new(session_string) }

		context "with a good session string" do
			let(:session_string) { "spideroak: 1 windows" }

			it "returns a Session object" do
				expect(session).to be_an_instance_of Tmux::Session
			end
		end

		context "with an invalid session string" do
			let(:session_string) { "blah blah blah" }

			it "raises an error" do
				expect{ session }.to raise_error(ArgumentError,
					"badly formatted session string: blah blah blah" )
			end
		end
	end

	describe "#name" do
		let(:session_string) { "spideroak: 1 windows" }
		subject(:session) { Tmux::Session.new(session_string) }

		it "takes the name from the session string" do
			expect(session.name).to eq "spideroak"
		end
	end
end
