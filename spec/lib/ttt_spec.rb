require 'spec_helper'
require 'ttt'

describe Position do
	
	context "#new" do
		it "should initialize a new board" do
			position = Position.new
			position.board.should == %w(- - -	
					            - - -
						    - - -)
			position.turn.should == "x"
		end
	end
end
