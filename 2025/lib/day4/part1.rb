require 'csv'
require 'pp'

module Day4
  class Part1
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
      map = Hash.new(0)
      rolls = Set.new

      lines = File.readlines(input_file).map { _1.strip.chars }
      lines.each_with_index do |row,y|
        row.each_with_index do |c, x|
          if c == "@"
            rolls.add([y,x])
            map[[y,x]] = 1
          else
            map[[y,x]] = 0
          end
        end
      end

      out = 0
      rolls.each do |y,x|
        adj = DIRS.sum do |d|
          map[[y+d[0],x+d[1]]]
        end
        out += 1 if adj < 4
      end

      out
    end
  end
end
