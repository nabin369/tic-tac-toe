require 'spec_helper'

describe Position do
	
	context "#new" do
		it "should initialize a new board" do
			position = Position.new
			position.board.should == %w(- - -	
					            - - -
						    - - -)
			position.turn.should == "x"
		end

		it "should initialize a position given a board and turn" do
			position = Position.new(%w(- x -
						   - - -
						   - o -), "o")
			position.board.should == %w(- x -
						    - - -
						    - o -)
			position.turn.should == "o"
		end
	end

	context "#move" do
		it "should make a move" do
			position = Position.new.move(0)		
			position.board.should == %w(x - -
						    - - -
						    - - -)
			position.turn.should == "o"
		end
	end

	context "#unmove" do	
		it "should undo the move" do
			position = Position.new.move(1).unmove
			init = Position.new
			position = init.board
			position = init.turn
		end
	end

	context "#possible moves" do
		it "should list possible moves for initial state" do
			Position.new.possible_moves.should == (0..8).to_a
		end

		it "should list possible moves for a position" do
			Position.new.move(4).possible_moves.should == [0,1,2,3,5,6,7,8]
		end
	end

	context "#win_lines" do
		it "should find winning column, rows and diagonals" do
			win_lines = Position.new(%W(0 1 2
						   				3 4 5
						    			6 7 8)).win_lines
			win_lines.should include(["0","1","2"])
			win_lines.should include(["3","4","5"])
			win_lines.should include(["6","7","8"])
			win_lines.should include(["0","3","6"])
			win_lines.should include(["1","4","7"])
			win_lines.should include(["2","5","8"])
			win_lines.should include(["0","4","8"])
			win_lines.should include(["2","4","6"])
		end
	end

	context "#win" do
		it "should determine no win" do
			Position.new.win?("x").should == false
			Position.new.win?("o").should == false
		end
		
		it "should determine win for x" do
			Position.new(%w(x x x
					- - -
					- o o)).win?("x").should == true
		end

		it "should determine win for o" do
			Position.new(%w(x x -
					- - -
					o o o)).win?("o").should == true
		end
	end
	
	context "#blocked" do
		it "should determine not blocked" do
			Position.new.blocked?.should == false
		end
	
		it "should determine blocked" do
			Position.new(%w(x o x
					o x o
					o x o)).blocked?.should == true
		end
	end

	context "#minimax" do
		it "should already won position" do
			Position.new(%w(x x x
					o o -
					x o o)).minimax.should == 100
		end

		it "should determine win in 1 for x" do
			Position.new(%w(x x -
					- - -
					- o o), "x").minimax.should == 99
		end
			
		it "should determine win in 1 for o" do
			Position.new(%w(x x -
					- - -
					- o o), "o").minimax.should == -99
		end
	end

	context "#evaluate leaf" do
		it "should determine nothing from initial position" do
			Position.new.evaluate_leaf.should == nil
		end
	
		it "should determine a win position for x" do 
			Position.new(%w(x x x
					- o o
					o - -)).evaluate_leaf.should == 100
		end
	
		it "should determine a win position for o" do 
			Position.new(%w(x x o
					- o -
					o - -), "o").evaluate_leaf.should == -100
		end

		it "should determine blocked" do 
			Position.new(%w(x x o
					o o x
					x x o)).evaluate_leaf.should == 0
		end
	end


	context "#best_move" do
		it "should find the winning move for x" do
		Position.new(%w(x x -
				- - -
				- o o), "x").best_move.should == 2
		end

		it "should find winning move for o" do
			Position.new(%w(x x -
					- - -
					- o o), "o").best_move.should == 6
		end
	end

	context "#end" do
		it "should see game has not ended" do
			Position.new.end?.should == false
		end
	
		it "should see game has ended due to win for x" do
			Position.new(%w(x x x
					o - o
					- - -)).end?.should == true
		end

		it "should see game has ended due to win for o" do
			Position.new(%w(x - x
					o o o
					- - -), "o").end?.should == true
		end

		it "should see game has no more move" do
			Position.new(%w(x o x
					o x o
					o x x)).end?.should == true
		end
	end

	context "#to_s" do
		it "should represent a position" do
			Position.new.move(3).move(4).to_s.should == <<-EOS
   |   |   
-----------
 x | o |   
-----------
   |   |   
	EOS
		end
	end   
end
