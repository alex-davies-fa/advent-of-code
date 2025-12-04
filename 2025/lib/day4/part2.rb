require 'csv'
require 'pp'

module Day4
  class Part2
    DIRS = [
      [-1,0],
      [1,0],
      [-1,1],
      [0,1],
      [1,1],
      [-1,-1],
      [0,-1],
      [1,-1],
    ]

    def run(input_file)
      lines = File.readlines(input_file).map { _1.strip.chars }

      rolls = Set.new
      lines.each_with_index do |row, y|
        row.each_with_index do |c, x|
          rolls.add([y,x]) if c == "@"
        end
      end

      init_count = rolls.length

      while remove_rolls!(rolls)
      end

      init_count - rolls.length
    end

    def remove_rolls!(rolls)
      to_remove = rolls.select do |y,x|
        DIRS.count { |d| rolls.include?([y+d[0],x+d[1]]) } < 4
      end

      rolls.subtract(to_remove)

      to_remove.any?
    end
  end
end
