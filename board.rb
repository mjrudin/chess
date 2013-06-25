#TODO: Knights need to jump pieces, pawns could only move two if initial move.
# -In pieces.rb/Pawn...implement attack position so pawns can move diagonal only
#  when there is an enemy piece present
# -'Check' means the kings position on the board is a valid_move for an enemy     piece |  valid_move(any enemy piece location, kings_location)
#    -if 'check' == true, then user is only allowed to move king
# -Checkmate calls on check. If check && no_valid_moves_remain, GAME OVER!
# -Setup coordinates so user can type a1 etc
# -HumanPlayer class
#    -prompts and gets
#-Switch king and queen for Black v. White (they need to be on opposite space)
#game runner to call on all methods until checkmate?

# -*- coding: utf-8 -*-

require "./pieces"

class Board

  attr_accessor :board

  def initialize
    @board = Array.new(8) {Array.new(8)}
  end

  def setup_board
    setup_pawns
    setup_other_pieces
  end

  def display_board
     @board.each do |row|
       displayed_board = []
       row.each do |piece|
         if !piece.nil?
           piece.set_graphic
           displayed_board << piece.graphic
         else
           displayed_board << " "
         end
       end
       puts displayed_board.join(" ")
     end
     puts "==============="
  end

  def move(current_location, desired_location)
    x1, y1 = current_location
    x2, y2 = desired_location
    if valid_move?(current_location, desired_location)
      @board[x1][y1].location = [x2,y2]
      @board[x2][y2] = @board[x1][y1]
      @board[x1][y1] = nil
    end
  end


  #private

  def enemy_piece?
    false
  end

  def valid_move?(current_location, desired_location)
    x1, y1 = current_location
    x2, y2 = desired_location
    tempx, tempy = x1, y1
    increment_x = (x2 <=> x1)
    increment_y = (y2 <=> y1)

    return false if !@board[x1][y1].possible_moves.include?(desired_location)
    while tempx != x2 || tempy != y2
      tempx += increment_x
      tempy += increment_y
      #If theres nothing at our incremental move, keep incrementing in
      #that direction
      if @board[tempx][tempy].nil?
        if [tempx, tempy] != desired_location
          next
        else
          return true
        end
      elsif [tempx, tempy] == desired_location
        #We found a piece, but now we check whether our location
        #was the final one. If so, then we capture it
        return enemy_piece? ? true : false
      else
        #INVALID MOVE, PROMPT USER AGAIN because something is blocking move
        return false
      end
    end
  end


  def setup_pawns
    [[1,:black],[6,:white]].each do |i, color|
      8.times do |j|
        @board[i][j] = Pawn.new([i,j],color)
      end
    end
  end

  def setup_other_pieces
    pieces_array = [Rook, Knight, Bishop, Queen, King,
                    Bishop, Knight, Rook]

    [[0,:black],[7,:white]].each do |i, color|
      8.times do |j|
        @board[i][j] = pieces_array[j].new([i,j], color)
      end
    end
  end
end

game = Board.new
game.setup_board
game.display_board
game.move([6,0],[5,1])
game.display_board
