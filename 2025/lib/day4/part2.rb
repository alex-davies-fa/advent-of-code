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

      init_count = rolls.length

      while true
        old_count = rolls.length
        remove_rolls!(rolls, map)
        break if old_count == rolls.length
      end

      init_count - rolls.length
    end

    def remove_rolls!(rolls, map)
      to_remove = []

      rolls.each do |y,x|
        adj = DIRS.sum do |d|
          map[[y+d[0],x+d[1]]]
        end
        to_remove << [y,x] if adj < 4
      end

      to_remove.each do |p|
        rolls.delete(p)
        map.delete(p)
      end
    end
  end
end
