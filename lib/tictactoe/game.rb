require_relative './position'

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


