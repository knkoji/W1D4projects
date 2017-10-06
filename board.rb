require_relative "tile"
require 'byebug'

class Board
  attr_reader :grid

  def self.empty_grid
    Array.new(9) do
      Array.new(9) { Tile.new(0) }
    end
  end

  def self.from_file(filename)
    lines = File.readlines(filename).map(&:chomp)
    tiles = lines.map do |line|
      line.split("").map do |char|
        number = Integer(char)
        Tile.new(number)
      end
    end
    # tiles.map { |row| Tile.new(num) }
    self.new(tiles)
  end

  def initialize(grid = self.empty_grid)
    @grid = grid
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    grid[x][y].value = value
  end

  def columns
    rows.transpose
  end

  def render
    puts "  #{(0..8).to_a.join(" ")}"
    grid.each_with_index do |row, i|
      puts "#{i} #{row.join(" ")}"
    end
  end


  def size
    grid.size
  end

  def rows
    grid
  end
  # alias_method :rows, :size

  def solved?
    # debugger
    rows.all? { |row| solved_set?(row) } &&
      columns.all? { |col| solved_set?(col) } &&
      squares.all? { |square| solved_set?(square) }
  end

  def solved_set?(tiles)
    nums = tiles.map(&:value)
    nums.sort == (1..9).to_a
  end

  def square(pos)
    tiles = []
    x, y = pos

    (x...x + 3).each do |i|
      (y...y + 3).each do |j|
        tiles << self[[i, j]]
      end
    end

    tiles
  end

  def squares
    (0..3).each do |x|
      (0..3).to_a.map { |y| square([x, y]) }
    end
  end

end
