require 'tk'
require 'tkextlib/tile'
root = TkRoot.new()

$from_button = nil
$piece_array = Array.new(88)

class ChessButton < Tk::Tile::Button

	def initialize(column,row,is_black,piece)
		@column = column
		@row = row
		@is_black = is_black
		@piece = piece
		@square_number = ((10*self.row)+self.column)
		if @piece == "empty"
			@moved = true
		else
			@moved = false
		end
		$piece_array[@square_number] = @piece
		return_location = Proc.new {play_game(self)}
		@button = Tk::Tile::Button.new(root) {command return_location}
		if is_black
			@image = TkPhotoImage.new(:file =>"images/black_" + piece + ".gif")
		else
			@image = TkPhotoImage.new(:file =>"images/white_" + piece + ".gif")
		end
		@button['image'] = @image
		@button.grid :column => @column, :row => @row
	end
	
	def change_piece(piece)
		if @is_black
			@image = TkPhotoImage.new(:file =>"images/black_" + piece + ".gif")
			@button['image'] = @image
		else
			@image = TkPhotoImage.new(:file =>"images/white_" + piece + ".gif")
			@button['image'] = @image
		end
		@piece = piece
	end
	
	attr_reader :column
	attr_reader :row
	attr_accessor :piece
	attr_reader :square_number
	attr_accessor :moved
		
end

$white_turn = true
game_over = false

def get_square_name(chosen)
	letters = Array.new
	letters = ['a','b','c','d','e','f','g','h']
	chosen = letters[(chosen-1) % 10].to_s + (9-((chosen-chosen%10)/10)).to_s
	return chosen
end
	

def play_game(button)
	if ($white_turn && button.piece[0...5] == "white") || (!$white_turn && button.piece[0...5] == "black")
		$from_button = button
	end
	if ($white_turn && button.piece[0...5] != "white" && $from_button != nil) || (!$white_turn && button.piece[0...5] != "black" && $from_button != nil)
		if (is_legal($from_button.square_number,button.square_number,$from_button.moved))
			$piece_array[button.square_number] = $piece_array[$from_button.square_number]
			$piece_array[$from_button.square_number] = "empty"
			
			button.change_piece($from_button.piece)
			$from_button.change_piece("empty")

			$from_button = nil
			$white_turn = !$white_turn
		else
			#something
		end
	end
end

def is_legal(from_square,to_square,from_moved)
	legal_move = false
	
	if ($piece_array[from_square] == "whitepawn")
		if((from_square - to_square == 10) && ($piece_array[to_square] == "empty"))
			legal_move = true
		end
		if((from_square - to_square == 20) && ($piece_array[to_square] == "empty")) && ($piece_array[(from_square-10)] == "empty") && !from_moved
			legal_move = true
		end
		if(((from_square - to_square) == 11) || ((from_square - to_square) == 9)) && $piece_array[to_square][0..4] == "black"
			legal_move = true
		end
	end
	
	if ($piece_array[from_square] == "blackpawn")
		if((from_square - to_square == -10) && ($piece_array[to_square] == "empty"))
			legal_move = true
		end
		if((from_square - to_square == -20) && ($piece_array[to_square] == "empty")) && ($piece_array[(from_square+10)] == "empty") && !from_moved
			legal_move = true
		end
		if(((from_square - to_square) == -11) || ((from_square - to_square) == -9)) && $piece_array[to_square][0..4] == "white"
			legal_move = true
		end
	end
	
	if ($piece_array[from_square][5..-1] == "rook")
		tick = 1
		legal_move = false
		if ((from_square > to_square) && ((from_square - to_square)%10 == 0))
			legal_move = true
			while (from_square - (10*tick)) > to_square
				if $piece_array[(from_square - (10*tick))] != "empty"
					legal_move = false
				end
				tick += 1
			end
			tick = 1
		end
			
		if ((from_square < to_square) && ((from_square - to_square)%10 == 0))
			legal_move = true
			while (from_square + (10*tick)) < to_square
				if $piece_array[(from_square + (10*tick))] != "empty"
					legal_move = false
				end
				tick += 1
			end
			tick = 1
		end
		
		if ((from_square > to_square) && ((from_square - to_square) < 9))
			legal_move = true
			while (from_square - (tick)) > to_square
				if $piece_array[(from_square - (tick))] != "empty"
					legal_move = false
				end
				tick += 1
			end
			tick = 1
		end
		
		if ((from_square < to_square) && ((to_square - from_square) < 9))
			legal_move = true
			while (from_square + (tick)) < to_square
				if $piece_array[(from_square + (tick))] != "empty"
					legal_move = false
				end
				tick += 1
			end
			tick = 1
		end
	end
	
	if ($piece_array[from_square][5..-1] == "queen")
		tick = 1
		legal_move = false
		if ((from_square > to_square) && ((from_square - to_square)%11 == 0))
			legal_move = true
			while (from_square - (11*tick)) > to_square
				if $piece_array[(from_square - (11*tick))] != "empty"
					legal_move = false
				end
				tick += 1
			end
			tick = 1
		end
			
		if ((from_square < to_square) && ((from_square - to_square)%11 == 0))
			legal_move = true
			while (from_square + (11*tick)) < to_square
				if $piece_array[(from_square + (11*tick))] != "empty"
					legal_move = false
				end
				tick += 1
			end
			tick = 1
		end
		
		if ((from_square > to_square) && ((from_square - to_square)%9 == 0))
			legal_move = true
			while (from_square - (9*tick)) > to_square
				if $piece_array[(from_square - (9*tick))] != "empty"
					legal_move = false
				end
				tick += 1
			end
			tick = 1
		end
			
		if ((from_square < to_square) && ((from_square - to_square)%9 == 0))
			legal_move = true
			while (from_square + (9*tick)) < to_square
				if $piece_array[(from_square + (9*tick))] != "empty"
					legal_move = false
				end
				tick += 1
			end
			tick = 1
		end
		
		if ((from_square > to_square) && ((from_square - to_square)%10 == 0))
			legal_move = true
			while (from_square - (10*tick)) > to_square
				if $piece_array[(from_square - (10*tick))] != "empty"
					legal_move = false
				end
				tick += 1
			end
			tick = 1
		end
			
		if ((from_square < to_square) && ((from_square - to_square)%10 == 0))
			legal_move = true
			while (from_square + (10*tick)) < to_square
				if $piece_array[(from_square + (10*tick))] != "empty"
					legal_move = false
				end
				tick += 1
			end
			tick = 1
		end
		
		if ((from_square > to_square) && ((from_square - to_square) < 9))
			legal_move = true
			while (from_square - (tick)) > to_square
				if $piece_array[(from_square - (tick))] != "empty"
					legal_move = false
				end
				tick += 1
			end
			tick = 1
		end
		
		if ((from_square < to_square) && ((to_square - from_square) < 9))
			legal_move = true
			while (from_square + (tick)) < to_square
				if $piece_array[(from_square + (tick))] != "empty"
					legal_move = false
				end
				tick += 1
			end
			tick = 1
		end
	end
	
	if ($piece_array[from_square][5..-1] == "bishop")
		tick = 1
		legal_move = false
		if ((from_square > to_square) && ((from_square - to_square)%11 == 0))
			legal_move = true
			while (from_square - (11*tick)) > to_square
				if $piece_array[(from_square - (11*tick))] != "empty"
					legal_move = false
				end
				tick += 1
			end
			tick = 1
		end
			
		if ((from_square < to_square) && ((from_square - to_square)%11 == 0))
			legal_move = true
			while (from_square + (11*tick)) < to_square
				if $piece_array[(from_square + (11*tick))] != "empty"
					legal_move = false
				end
				tick += 1
			end
			tick = 1
		end
		
		if ((from_square > to_square) && ((from_square - to_square)%9 == 0))
			legal_move = true
			while (from_square - (9*tick)) > to_square
				if $piece_array[(from_square - (9*tick))] != "empty"
					legal_move = false
				end
				tick += 1
			end
			tick = 1
		end
			
		if ((from_square < to_square) && ((from_square - to_square)%9 == 0))
			legal_move = true
			while (from_square + (9*tick)) < to_square
				if $piece_array[(from_square + (9*tick))] != "empty"
					legal_move = false
				end
				tick += 1
			end
			tick = 1
		end
	end
	
	if ($piece_array[from_square][5..-1] == "king")
		if (from_square - to_square).abs == 1 || (9..11).include?((from_square - to_square).abs)
			legal_move = true
		end
	end
	
	if ($piece_array[from_square][5..-1] == "knight")
		if ((from_square - to_square).abs == 21 || (from_square - to_square).abs == 19) || ((from_square - to_square).abs == 12 || (from_square - to_square).abs == 8)
			legal_move = true
		end
	end
	
	return legal_move
end


a1 = ChessButton.new(1,8,true,"whiterook")
b1 = ChessButton.new(2,8,false,"whiteknight")
c1 = ChessButton.new(3,8,true,"whitebishop")
d1 = ChessButton.new(4,8,false,"whitequeen")
e1 = ChessButton.new(5,8,true,"whiteking")
f1 = ChessButton.new(6,8,false,"whitebishop")
g1 = ChessButton.new(7,8,true,"whiteknight")
h1 = ChessButton.new(8,8,false,"whiterook")

a2 = ChessButton.new(1,7,false,"whitepawn")
b2 = ChessButton.new(2,7,true,"whitepawn")
c2 = ChessButton.new(3,7,false,"whitepawn")
d2 = ChessButton.new(4,7,true,"whitepawn")
e2 = ChessButton.new(5,7,false,"whitepawn")
f2 = ChessButton.new(6,7,true,"whitepawn")
g2 = ChessButton.new(7,7,false,"whitepawn")
h2 = ChessButton.new(8,7,true,"whitepawn")

a3 = ChessButton.new(1,6,true,"empty")
b3 = ChessButton.new(2,6,false,"empty")
c3 = ChessButton.new(3,6,true,"empty")
d3 = ChessButton.new(4,6,false,"empty")
e3 = ChessButton.new(5,6,true,"empty")
f3 = ChessButton.new(6,6,false,"empty")
g3 = ChessButton.new(7,6,true,"empty")
h3 = ChessButton.new(8,6,false,"empty")

a4 = ChessButton.new(1,5,false,"empty")
b4 = ChessButton.new(2,5,true,"empty")
c4 = ChessButton.new(3,5,false,"empty")
d4 = ChessButton.new(4,5,true,"empty")
e4 = ChessButton.new(5,5,false,"empty")
f4 = ChessButton.new(6,5,true,"empty")
g4 = ChessButton.new(7,5,false,"empty")
h4 = ChessButton.new(8,5,true,"empty")

a5 = ChessButton.new(1,4,true,"empty")
b5 = ChessButton.new(2,4,false,"empty")
c5 = ChessButton.new(3,4,true,"empty")
d5 = ChessButton.new(4,4,false,"empty")
e5 = ChessButton.new(5,4,true,"empty")
f5 = ChessButton.new(6,4,false,"empty")
g5 = ChessButton.new(7,4,true,"empty")
h5 = ChessButton.new(8,4,false,"empty")

a6 = ChessButton.new(1,3,false,"empty")
b6 = ChessButton.new(2,3,true,"empty")
c6 = ChessButton.new(3,3,false,"empty")
d6 = ChessButton.new(4,3,true,"empty")
e6 = ChessButton.new(5,3,false,"empty")
f6 = ChessButton.new(6,3,true,"empty")
g6 = ChessButton.new(7,3,false,"empty")
h6 = ChessButton.new(8,3,true,"empty")

a7 = ChessButton.new(1,2,true,"blackpawn")
b7 = ChessButton.new(2,2,false,"blackpawn")
c7 = ChessButton.new(3,2,true,"blackpawn")
d7 = ChessButton.new(4,2,false,"blackpawn")
e7 = ChessButton.new(5,2,true,"blackpawn")
f7 = ChessButton.new(6,2,false,"blackpawn")
g7 = ChessButton.new(7,2,true,"blackpawn")
h7 = ChessButton.new(8,2,false,"blackpawn")

a8 = ChessButton.new(1,1,false,"blackrook")
b8 = ChessButton.new(2,1,true,"blackknight")
c8 = ChessButton.new(3,1,false,"blackbishop")
d8 = ChessButton.new(4,1,true,"blackqueen")
e8 = ChessButton.new(5,1,false,"blackking")
f8 = ChessButton.new(6,1,true,"blackbishop")
g8 = ChessButton.new(7,1,false,"blackknight")
h8 = ChessButton.new(8,1,true,"blackrook")

Tk.mainloop()