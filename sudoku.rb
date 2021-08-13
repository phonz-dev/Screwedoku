require_relative "board"
require "byebug"
class SudokuGame

  def self.from_file(filename)
    rows = File.readlines(filename).map(&:chomp)
    tiles = rows.map do |row|
      nums = row.split("").map(&:to_i)
      nums.map { |num| Tile.new(num) }
    end
    self.new(tiles)
  end

  def initialize(board)
    @board = Board.new(board)
  end

  # def method_missing(method_name, *args)
  #   if method_name =~ /val/
  #     Integer(1)
  #   else
  #     string = args[0]
  #     string.split(",").map! { |char| Integer(char) + 1 + rand(2) + " is the position"}
  #   end
  # end

  def get_pos
    pos = nil
    until pos && valid_pos?(pos)
      puts "Please enter a position on the board (e.g., '3,4')"
      print "> "

      begin
        pos = parse_pos(gets.chomp)
      rescue
        puts "Invalid position entered (did you use a comma?)"
        puts ""
        pos = nil
      end
    end
    pos
  end

  def get_val
    val = nil
    until val && valid_val?(val)
      puts "Please enter a value between 1 and 9 (0 to clear the tile)"
      print "> "
      val = parse_val(gets.chomp)
    end
    val
  end

  def parse_pos(pos)
    pos.split(",").map(&:to_i)
  end

  def parse_val(val)
    Integer(val)
  end

  def play_turn
    board.render
    pos = get_pos
    val = get_val
    board[pos] = val
  end

  def run
    play_turn until solved?
    board.render
    puts "Congratulations, you win!"
  end

  def solved?
    board.solved?
  end

  def valid_pos?(pos)
    if pos.is_a?(Array) &&
      pos.length == 2 &&
      pos.all? { |x| x.in?(0, board.size - 1) }
      return true
    else
      get_pos
    end
  end

  def valid_val?(val)
    val.is_a?(Integer) ||
      val.between?(0, 9)
  end

  private
  attr_reader :board
end


game = SudokuGame.from_file("puzzles/sudoku1.txt")
game.run