class Position
	attr_accessor :board, :turn

	def initialize
		@dim = 3
		@size = @dim * @dim
		@board = Array.new(@size, "-")
		@turn = "x"
	end
end
