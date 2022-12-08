require 'csv'
require 'pp'

module Day8
  class Part2
    def run(input_file)
      trees = File.readlines(input_file).map { |l| l.strip.chars.map(&:to_i) }
      h = trees.length
      w = trees.first.length

      [*0...h].product([*0...w])
        .map { |y,x| score(trees,x,y) }
        .max
    end

    def score(trees,x,y)
      left = x == 0 ? [] : trees[y][0..x-1].reverse
      right = trees[y][x+1..-1]
      top = y == 0 ? [] : trees.transpose[x][0..y-1].reverse
      bot = trees.transpose[x][y+1..-1]

      [left, right, top, bot].map { |row| dir_score(row, trees[y][x]) }.inject(&:*)
    end

    def dir_score(row, h)
      return 0 if row.empty?
      clear_view = row.take_while { |tree| tree < h }.length
      clear_view += 1 if clear_view < row.length
      clear_view
    end
  end
end
