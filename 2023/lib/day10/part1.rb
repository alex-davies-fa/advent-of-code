require 'csv'
require 'pp'

module Day10
  class Part1
    SHAPES = {
      "|" => [[-1,0], [1,0]],
      "-" => [[0,-1], [0,1]],
      "L" => [[-1,0], [0,1]],
      "J" => [[-1,0], [0,-1]],
      "7" => [[1,0], [0,-1]],
      "F" => [[1,0], [0,1]],
    }

    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      start = nil
      conns = {}
      lines.each_with_index do |line, y|
        line.split('').each_with_index do |c, x|
          case c
          when '.'
            next
          when 'S'
            start = [y,x]
          else
            conns[[y,x]] = [add([y,x],SHAPES[c][0]), add([y,x],SHAPES[c][1])]
          end
        end
      end

      path = [start]

      # Find (one of the two) adjacent paths
      [-1,0,1].repeated_permutation(2) do |d|
        pos = add(start,d)
        if conns[pos]&.include?(start)
          path << pos
          break
        end
      end

      # Walk along path until we get back to the start
      while path.last != start
        path << conns[path.last].reject { _1 == path[-2]}.first
      end

      path.length / 2
    end

    def add(a,b)
      [a[0] + b[0], a[1] + b[1]]
    end
  end
end
