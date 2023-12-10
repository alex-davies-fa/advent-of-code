require 'csv'
require 'pp'

module Day10
  class Part2
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
      spaces = Set.new

      lines.each_with_index do |line, y|
        line.split('').each_with_index do |c, x|
          case c
          when '.'
            spaces.add([y,x])
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

      loop_vals = Set.new(path)

      # Get all candidate fill start spots
      inner_spots = Set.new
      path.each_cons(2) do |p1, p2|
        spots = get_inner(p1,p2)
        spots.each { |spot| inner_spots.add(spot) unless loop_vals.include?(spot) }
      end

      fringe = inner_spots.to_a
      inner = Set.new()

      while fringe.any? do
        current = fringe.pop
        inner.add(current)
        neighbours(current).each do |n|
          unless loop_vals.include?(n) || inner.include?(n)
            fringe << n
          end
        end
      end

      (0..lines.length).each do |y|
        out = ""
        (0..lines[0].length).each do |x|
          if loop_vals.include?([y,x])
            out << lines[y][x]
          elsif inner_spots.include?([y,x])
            out << "x".red
          else
            out << ".".blue
          end
        end
        puts out
      end

      inner.size
    end

    def get_inner(a,b)
      flip = 1 # Hardcoded direction of loop, sorry (has to change for test input)
      diff = [b[0] - a[0], b[1] - a[1]]
      dir = [flip*diff[1], -1*flip*diff[0]]
      [add(a,dir), add(b, dir)]
    end

    def neighbours(p)
      dirs = [[1,0],[-1,0],[0,1],[0,-1]]
      dirs.map { |dir| add(p, dir) }
    end

    def add(a,b)
      [a[0] + b[0], a[1] + b[1]]
    end

  end
end

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end


  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end
end
