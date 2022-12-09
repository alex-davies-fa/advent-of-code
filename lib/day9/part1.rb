require 'csv'
require 'pp'
require 'matrix'
require 'set'

module Day9
  class Part1
    DIR_MAP = {
      "R" => Vector[1,0],
      "L" => Vector[-1,0],
      "U" => Vector[0,1],
      "D" => Vector[0,-1],
    }

    def run(input_file)
      lines = File.readlines(input_file)
      moves = read_moves(lines)


      head = Vector[0,0]
      tail = Vector[0,0]

      tail_positions = Set.new([tail])

      moves.each do |m|
        head += m
        tail = follow(head, tail)
        tail_positions.add(tail)
        pp head
        pp tail
        puts
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
