require 'spec_helper'

describe TTT do

	context "#ask for players" do
		it "should ask who should play first" do
			ttt = TTT.new
			ttt.stub(:gets => "1\n")
			ttt.stub(:puts)
			ttt.stub(:print)
			ttt.ask_for_player.should == "human"
		end
	end
	
	context "#ask for move" do
		it "should ask for move" do
			position = Position.new
			ttt = TTT.new
			ttt.stub(:gets => "1\n")
			ttt.stub(:puts)
			ttt.stub(:print)
			ttt.ask_for_move(position).should == 1
		end
	end
end
