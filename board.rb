# -*- coding: utf-8 -*-

require "./pieces"

class Board
  attr_accessor :board

  def initialize
    @board = Array.new(8) {Array.new(8)}
    @piece_array = Array.new(2) {[]}
    @kings = []
  end

  def setup_board
    setup_pawns
    setup_other_pieces
  end

  def display_board
     @board.each_with_index do |row, index|
       displayed_board = []
       displayed_board << "#{8-index}"
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
     puts "  a b c d e f g h"
     puts "================="
  end

  def move(current_location, desired_location, color)
    x1, y1 = current_location
    x2, y2 = desired_location
    @board[x1][y1].color == color
    if is_a_knight?(current_location)
      if @board[x2][y2].nil? || enemy_piece?(current_location, desired_location)
        move_knight(current_location, desired_location)
      else
        raise "Invalid move!"
      end
    elsif valid_move?(current_location, desired_location)
      move_on_board(current_location, desired_location)
    else
      raise "Invalid move!"
    end
  end


  #private

  def move_on_board(current_location, desired_location)
    x1, y1 = current_location
    x2, y2 = desired_location
    #tells piece its new position
    @board[x1][y1].location = [x2,y2]
    #set the objects location to nil if it was captured
    @board[x2][y2].location = nil unless @board[x2][y2].nil?
    @board[x2][y2] = @board[x1][y1]
    @board[x1][y1] = nil
  end

  def is_a_knight?(current_location)
    x1,y1 = current_location
    @board[x1][y1].is_a?(Knight)
  end

  def move_knight(current_location, desired_location)
    x1, y1 = current_location
    if @board[x1][y1].possible_moves.include?(desired_location)
      move_on_board(current_location, desired_location)
    else
      raise "Invalid move!"
    end
  end

  def enemy_piece?(current_location, desired_location)
    x1,y1 = current_location
    x2,y2 = desired_location
    @board[x1][y1].color != @board[x2][y2].color
  end

  def valid_move?(current_location, desired_location)
    x1, y1 = current_location
    x2, y2 = desired_location
    tempx, tempy = x1, y1
    increment_x = (x2 <=> x1)
    increment_y = (y2 <=> y1)

    return false if !@board[x1][y1].possible_moves.include?(desired_location)
    while tempx != x2 || tempy != y2
      tempx += increment_x if tempx != x2
      tempy += increment_y if tempy != y2
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
        return enemy_piece?(current_location, desired_location)
      else
        #INVALID MOVE, PROMPT USER AGAIN because something is blocking move
        return false
      end
    end
  end


  def setup_pawns
    #index 0 refers to black objects, 1 to white objects
    index = 0
    [[1,:black],[6,:white]].each do |i, color|
      8.times do |j|
        @board[i][j] = Pawn.new([i,j],color, @board)
        # for checking when kings location is included in the valid move of
        # another piece
        @piece_array[index] << @board[i][j]
      end
      index += 1
    end
  end

  def setup_other_pieces
    pieces_array = [Rook, Knight, Bishop, Queen, King,
                    Bishop, Knight, Rook]

    index = 0
    [[0,:black],[7,:white]].each do |i, color|
      8.times do |j|
        @board[i][j] = pieces_array[j].new([i,j], color)
        @piece_array[index] << @board[i][j]
      end
      index += 1
    end
    @kings = [@board[0][4], @board[7][4]]
  end


  def in_check?(enemy_color)
    index = enemy_color == :white ? 0 : 1
      @piece_array[index].each do |piece|
        next if piece.location.nil?
        if piece.is_a?(Pawn)
          attacks = piece.get_attack_moves
          return true if !piece.nil? && attacks.include?(@kings[1-index].location)
        else
          return true if valid_move?(piece.location, @kings[1-index].location)
        end
      end
    false
  end

  def in_checkmate?(enemy_color)
    checkmate_status = true

    index = enemy_color == :white ? 0 : 1
    @piece_array[1-index].each do |piece|
      next if piece.location.nil?
      next if piece.nil?
      pieces_possible_moves = piece.possible_moves
      next if pieces_possible_moves.nil?
      pieces_possible_moves.each do |temp_move|
        if !piece.location.nil? && valid_move?(piece.location, temp_move)
          old_location = piece.location
          piece.location = temp_move
          checkmate_status = false if !in_check?(enemy_color)
          piece.location = old_location
        end
      end
    end
    checkmate_status
  end

end
