require 'csv'
require 'pp'

module Day8
  class Part1
    def run(input_file)
      trees = File.readlines(input_file).map { |l| l.strip.chars.map(&:to_i) }
      h = trees.length
      w = trees.first.length

      [*0...h].product([*0...w])
        .count { |y,x| visible?(trees,x,y) }
    end

    def visible?(trees,x,y)
      left = x == 0 ? [] : trees[y][0..x-1]
      right = trees[y][x+1..-1]
      top = y == 0 ? [] : trees.transpose[x][0..y-1]
      bot = trees.transpose[x][y+1..-1]
      [left, right, top, bot].any? { |row| all_lower(row, trees[y][x]) }
    end

    def all_lower(row, h)
      row.all? { |tree| tree < h }
    end
  end
end
