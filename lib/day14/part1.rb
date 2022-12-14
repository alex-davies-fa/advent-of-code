require 'csv'
require 'pp'
require 'matrix'

module Day14
  class Part1
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

        moves = [Vector[0, 1], Vector[-1, 1], Vector[1,1], nil]
        sand = Set.new
        abyss = false

        while !abyss do
          blocked = false
          sand_pos = Vector[500,0]
          while !blocked && !abyss do
            moves.each do |move|
              if move.nil?
                blocked = true
                sand << sand_pos
                break
              end

              new_pos = sand_pos + move
              next if blocked?(new_pos, rocks, sand)

              sand_pos = new_pos
              break
            end

            paint(rocks,sand,sand_pos)

            abyss = true if sand_pos[1] >= max_y_pos
          end
      end

      puts sand.length

      nil
    end

    def blocked?(pos, rocks, sand)
      return true if rocks.include?(pos)
      return true if sand.include?(pos)
      false
    end

    def paint(rocks, sand, curr_sand)
      min_x = 460
      max_x = 510
      min_y = 10
      max_y = 57

      out = ""
      (min_y..max_y).each do |y|
        (min_x..max_x).each do |x|
          (out << '🟫'; next) if rocks.include?(Vector[x,y])
          (out << '🟨'; next) if sand.include?(Vector[x,y]) || curr_sand == Vector[x,y]
          out << '⬛'
        end
        out << "\n"
      end

      print out

      # sleep(0.01)

      print "\033[#{max_y-min_y+1}A"
      print "\r"
    end
  end
end
