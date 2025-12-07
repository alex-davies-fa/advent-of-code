require 'csv'
require 'pp'

module Day7
  class Part2
    def run(input_file)
      splitters = Hash.new(false)
      start = nil

      lines = File.readlines(input_file).map { _1.strip.chars }
      lines.each_with_index do |row,y|
        row.each_with_index do |c, x|
          if c == "S"
            start = [y,x]
          elsif c == "^"
            splitters[[y,x]] = true
          end
        end
      end

      paths_from(start[0],start[1],splitters,lines.length-1)
    end

    def paths_from(y,x,splitters,max_depth,cache = {})
      return 1 if y == max_depth
      return cache[[y,x]] if cache[[y,x]]

      cache[[y,x]] = 
        if splitters[[y,x]]
          paths_from(y+1,x-1,splitters,max_depth,cache) + paths_from(y+1,x+1,splitters,max_depth,cache)
        else
          paths_from(y+1,x,splitters,max_depth,cache)
        end
    end
  end
end
