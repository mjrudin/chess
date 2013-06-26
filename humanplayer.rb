# -*- coding: utf-8 -*-
require "./board"

class HumanPlayer

  attr_accessor :color, :other_color

  def initialize(color, other_color, board_object)
    @color = color
    @other_color = other_color
    @board_object = board_object
    @board = @board_object.board
  end

  def starting_prompt
    puts "Welcome to Chess!"
  end

  def our_piece?(x, y)
    raise "Invalid move!" unless !@board[x][y].nil? && @board[x][y].color == @color
  end

  def get_piece_location
    puts "\n#{@color.capitalize}, select a piece (in the form 'a 4')."
    input = gets.chomp.split(/\s*/)
    column_str = "abcdefgh"
    initial_x = input[1].to_i
    initial_y = column_str.index(input[0])
    our_piece?(8-initial_x,initial_y)
    return [8-initial_x,initial_y]
  end


  def get_desired_location
    puts "\n#{@color.capitalize}, select a spot to move to (in the form 'a 4')."
    input = gets.chomp.split(/\s*/)
    column_str = "abcdefgh"
    desired_x = input[1].to_i
    desired_y = column_str.index(input[0])

    return [8-desired_x,desired_y]
  end

  def move
    begin
      initial_location = get_piece_location
      desired_location = get_desired_location
      @board_object.move(initial_location,desired_location, @color)
    rescue StandardError => e
      puts e
      retry
    end
  end


  def check
    begin
      puts "#{@other_color.capitalize} has checked #{@color.capitalize}"
      while true

        @board_object.display_board
        puts "#{@color.capitalize} must uncheck."

        initial_location = get_piece_location
        desired_location = get_desired_location

        @board_object.move(initial_location,desired_location, @color)
        if @board_object.in_check?(@color)
          #If color's move didn't make color unchecked, undo that move
          @board_object.move_on_board(desired_location, initial_location)
        else
          break
        end
      end
    rescue StandardError => e
      puts e
      retry
    end
  end

  def checkmate
    puts "Checkmate. \n\n*** #{@other_color.capitalize} wins! ***"
  end
end
