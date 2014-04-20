#!/usr/bin/env ruby

class Position
	attr_accessor :board, :turn

	def initialize(board=nil, turn="x")
		@dim = 3
		@size = @dim * @dim
		@board = board || Array.new(@size, "-")
		@turn = turn
		@moveList = []
	end
	
	def move index
		@board[index] = @turn
		@turn = other_turn
		@moveList << index
		self
	end
	
	def other_turn
		@turn == "x" ? "o" : "x"
	end

	def unmove 
		@board[@moveList.pop] = "-"
		@turn = other_turn
		self
	end

	def possible_moves
		@board.map.with_index { |piece, idx| piece == "-" ? idx : nil }.compact
	end

	def win_lines
		(
		(0..@size.pred).each_slice(@dim).to_a +
		(0..@size.pred).each_slice(@dim).to_a.transpose	+
		[(0..@size.pred).step(@dim.succ).to_a] +
		[(@dim.pred..(@size-@dim)).step(@dim.pred).to_a]
		).map {|lines| lines.map {|index| @board[index]}}	
	end

	def win? piece
		win_lines.any? { |line|
			line.all? { |line_piece| line_piece == piece }
		}
	end

	def blocked?
		win_lines.all? { |line|
			line.any? { |line_piece| line_piece == "x" } &&
			line.any? { |line_piece| line_piece == "o" }
		}	
	end

	def evaluate_leaf
		return  100 if win?("x")
		return -100 if win?("o")
		return    0 if blocked?
	end

	def minmax index=nil
		move(index) if index
		leaf_value = evaluate_leaf
		return leaf_value if leaf_value
		possible_moves.map {|index|
			minmax(index).send(@turn == "x" ? :- : :+, @moveList.count+1)
		}.send(@turn == "x" ? :max : :min)
	ensure
		unmove if index
	end
	
	def best_move
		possible_moves.send(@turn == "x" ? :max_by : :min_by) { |idx| minmax(idx)}
	end

	def end?
		win?("x") || win?("o") || @board.count("-") == 0
	end

	def to_s
		@board.each_slice(@dim).map { |line|
		 " " + line.map {|piece| piece == "-" ? " " : piece}.join(" | ") + " " 
		}.join("\n-----------\n") + "\n"
	end
end

class TTT

	def ask_for_player
		puts "Who do you want to play first?"
		puts "1. human"
		puts "2. computer"

		while true
			print "choice:"
			ans = gets.chomp
			return "human" if ans == "1"
			return "computer" if ans == "2"
		end	
	end

	def ask_for_move position
		while true
			print "move: "
			ans = gets.chomp
			return ans.to_i if ans =~ /^\d+$/ && position.board[ans.to_i] == "-"
		end	
	end

	def other_player
		@player == "human" ? "computer" : "human"
	end
	
	def play_game
		@player = ask_for_player
		position = Position.new
		while !position.end?
			puts position
			puts
			index = @player == "human" ? ask_for_move(position) : position.best_move
			position.move(index)
			@player = other_player
		end
		puts position
		if position.blocked?
			puts "draw"
		else
			puts "winner: #{other_player}"
		end
	end

end

if __FILE__ == $0
	ttt = TTT.new
	ttt.play_game
end

