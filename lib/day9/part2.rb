require 'csv'
require 'pp'
require 'matrix'
require 'set'

module Day9
  class Part2
    DIR_MAP = {
      "R" => Vector[1,0],
      "L" => Vector[-1,0],
      "U" => Vector[0,1],
      "D" => Vector[0,-1],
    }

    def run(input_file)
      lines = File.readlines(input_file)
      moves = read_moves(lines)

      knots = [Vector[0,0]] * 10

      tail_positions = Set.new([knots.last])

      moves.each do |m|
        knots[0] += m
        (1..9).each { |i| knots[i] = follow(knots[i-1],knots[i]) }
        tail_positions.add(knots.last)
      end

      puts tail_positions.length
      nil
    end

    def follow(head, tail)
      diff = head - tail
      return tail if diff.map(&:abs).max <= 1

      step = diff.map { |d| d <=> 0 } # Normalize each element
      tail + step
    end

    def read_moves(lines)
      lines.flat_map do |line|
        dir, num = line.split
        [DIR_MAP[dir]] * num.to_i
      end
    end
  end
end
