require 'csv'
require 'pp'

module Day7
  class Part1
    def run(input_file)
      map = Hash.new(0)
      start = nil

      lines = File.readlines(input_file).map { _1.strip.chars }
      lines.each_with_index do |row,y|
        row.each_with_index do |c, x|
          if c == "S"
            start = [y,x]
          elsif c == "^"
            map[[y,x]] = "^"
          end
        end
      end

      xs = [start[1]]
      y = start[0]
      splits = 0

      while y <= lines.length
        new_xs = []
        xs.each do |x|
          if map[[y,x]] == "^"
            new_xs.append(x-1,x+1)
            splits += 1
          else
            new_xs << x
          end
        end

        xs = new_xs.uniq
        y += 1
      end

      splits
    end
  end
end
