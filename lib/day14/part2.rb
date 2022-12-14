require 'csv'
require 'pp'
require 'matrix'

module Day14
  class Part2
    class Line
      attr_reader :a, :b

      def initialize(a, b)
        @a = a
        @b = b
      end

      def xs
        [a[0],b[0]]
      end

      def ys
        [a[1],b[1]]
      end

      def points_on_line
        if xs[0] == xs[1]
          (ys.min..ys.max).map { |y| Vector[xs[0], y] }
        elsif ys[0] == ys[1]
          (xs.min..xs.max).map { |x| Vector[x, ys[0]] }
        end
      end

      def to_s
        "[#{a[0]},#{a[1]}] -> [#{b[0]},#{b[1]}]"
      end
    end

    def run(input_file)
      lines = File.readlines(input_file)
      rock_lines =
        lines.flat_map do |line|
          path =
            line.split(" -> ").map do |coords|
              x,y = coords.split(",").map(&:to_i)
              Vector[x,y]
            end
          path.each_cons(2).map { Line.new(_1, _2) }
        end

        rocks = Set.new
        rock_lines.each { rocks.merge(_1.points_on_line) }

        max_y_pos = rocks.to_a.map { |rock| rock[1] }.max
        floor_pos = max_y_pos + 2

        moves = [Vector[0, 1], Vector[-1, 1], Vector[1,1], nil]
        sand = Set.new
        full = false

        itr = 0

        while !full do
          blocked = false
          sand_pos = Vector[500,0]
          itr += 1

          while !blocked && !full do
            moves.each do |move|
              if move.nil?
                blocked = true
                sand << sand_pos
                break
              end

              new_pos = sand_pos + move
              next if blocked?(new_pos, rocks, sand, floor_pos)

              sand_pos = new_pos
              break
            end

            full = true if sand_pos == Vector[500, 0]
          end

          if itr % 100 == 0
            puts "#{itr}: #{sand.to_a.map{ _1[1] }.min }"
          end
      end

      puts
      puts sand.length

      nil
    end

    def blocked?(pos, rocks, sand, floor_pos)
      return true if pos[1] == floor_pos
      return true if rocks.include?(pos)
      return true if sand.include?(pos)
      false
    end
  end
end
