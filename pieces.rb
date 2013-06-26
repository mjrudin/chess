# -*- coding: utf-8 -*-
class Piece
  attr_accessor :location, :color, :graphic

  def initialize(location, color)
    @location = location
    @color = color
  end

  def possible_moves
    #two element array
    [[location[0]+1,location[1]]]
  end

  #returns true if move is valid
  def on_board?(possible_move)
    x_cord,y_cord = possible_move
    (0..7).include?(x_cord) && (0..7).include?(y_cord)
  end
end

class King < Piece

  def possible_moves
    possible_move_list = []
    #sets x = @location[0]   y = @location[1]
    x_cord,y_cord = @location
    #loads possible moves as arrays into possible_move_list
    (-1..1).each do |i|
      (-1..1).each do |j|
        possible_move = [x_cord + i, y_cord + j]
        possible_move_list << possible_move if on_board?(possible_move)
      end
    end
    #delete the initial location (user must move)
    possible_move_list.delete(@location)
    possible_move_list
  end

  def set_graphic
    if @color == :black
      @graphic = :♚
    else
      @graphic = :♔
    end
  end

end

class Queen < Piece

  #Any distance, in any straight line
  def possible_moves
    possible_move_list = []
    #sets x = @location[0]   y = @location[1]
    x_cord,y_cord = @location
    #loads possible moves as arrays into possible_move_list
    (-7..7).each do |i|
      (-7..7).each do |j|
        if i.abs > 0 && j.abs > 0
          next if i.abs != j.abs
        end
        possible_move = [x_cord + i, y_cord + j]
        possible_move_list << possible_move if on_board?(possible_move)
      end
    end
    #delete the initial location (user must move)
    possible_move_list.delete(@location)
    possible_move_list
  end

  def set_graphic
    if @color == :black
      @graphic = :♛
    else
      @graphic = :♕
    end
  end

end

class Rook < Piece

  #Only horizontal or only vertical move
  def possible_moves
    possible_move_list = []
    #sets x = @location[0]   y = @location[1]
    x_cord,y_cord = @location
    #loads possible moves as arrays into possible_move_list
    (-7..7).each do |i|
      possible_move = [x_cord + i, y_cord]
      possible_move_list << possible_move if on_board?(possible_move)
      possible_move = [x_cord, y_cord + i]
      possible_move_list << possible_move if on_board?(possible_move)
    end
    #delete the initial location (user must move)
    possible_move_list.delete(@location)
    possible_move_list
  end

  def set_graphic
    if @color == :black
      @graphic = :♜
    else
      @graphic = :♖
    end
  end

end

class Bishop < Piece

  #Only diagonal moves
  def possible_moves
    possible_move_list = []
    #sets x = @location[0]   y = @location[1]
    x_cord,y_cord = @location
    #loads possible moves as arrays into possible_move_list
    (-7..7).each do |i|
      (-7..7).each do |j|
        next if i == 0 || j == 0 || i.abs != j.abs
        possible_move = [x_cord + i, y_cord + j]
        possible_move_list << possible_move if on_board?(possible_move)
      end
    end
    #delete the initial location (user must move)
    possible_move_list.delete(@location)
    possible_move_list
  end

  def set_graphic
    if @color == :black
      @graphic = :♝
    else
      @graphic = :♗
    end
  end

end

class Knight < Piece

  #Two and one
  def possible_moves
    possible_move_list = []
    #sets x = @location[0]   y = @location[1]
    x_cord,y_cord = @location
    #loads possible moves as arrays into possible_move_list
    (-2..2).each do |i|
      (-2..2).each do |j|
        next if i == 0 || j == 0 || i.abs == j.abs
        possible_move = [x_cord + i, y_cord + j]
        possible_move_list << possible_move if on_board?(possible_move)
      end
    end
    possible_move_list
  end

  def set_graphic
    if @color == :black
      @graphic = :♞
    else
      @graphic = :♘
    end
  end

end

class Pawn < Piece

  attr_accessor :board

  def initialize(location, color, board)
    super(location, color)
    @board = board
  end


  def add_attack_moves(possible_move_list)
    row_direction = @color == :black ? 1 : -1
    x_cord,y_cord = @location
    [-1,1].each do |j|
      diagonal_position = @board[x_cord + row_direction][y_cord+j]
      if !diagonal_position.nil? && diagonal_position.color != @color
        possible_move_list << [x_cord + row_direction, y_cord+j]
      end
    end
    possible_move_list
  end

  def possible_moves
    possible_move_list = []
    #sets x = @location[0]   y = @location[1]
    x_cord,y_cord = @location
    #loads possible moves as arrays into possible_move_list (x is row)
    (-1..1).each do |i|
        possible_move = [x_cord + i, y_cord]
        possible_move_list << possible_move if on_board?(possible_move)
    end

    case @color
    #if black move, delete the possible white moves, then add 2-space move too
    #Only allow double moves for initial pawn movement
    when :black
      possible_move_list.delete_if{ |x,y| x <= x_cord }
      possible_move_list << [x_cord + 2, y_cord] if x_cord == 1
    when :white
      possible_move_list.delete_if{ |x,y| x >= x_cord }
      possible_move_list << [x_cord - 2, y_cord] if x_cord == 6
    end

    add_attack_moves(possible_move_list)
    possible_move_list
  end

  def set_graphic
    if @color == :black
      @graphic = :♟
    else
      @graphic = :♙
    end
  end

end