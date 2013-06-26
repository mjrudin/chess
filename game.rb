require "./humanplayer"
require "./board"

class Game

  def initialize
    @board_object = Board.new
    @board_object.setup_board
  end

  def play
    @board_object.display_board
    h1 = HumanPlayer.new(:white, :black, @board_object)
    h2 = HumanPlayer.new(:black, :white, @board_object)
    player = h1

    while true
      player_checked = @board_object.in_check?(player.color)
      player_checkmate = @board_object.in_checkmate?(player.color)
      if player_checked && !player_checkmate
         player.check
      elsif player_checkmate
        player.checkmate
        break
      else
        player.move
      end
      @board_object.display_board

      player = player == h1 ? h2 : h1
    end
  end
end

game = Game.new
game.play