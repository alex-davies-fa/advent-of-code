require 'csv'
require 'pp'

module Day14
  DEBUG = true
  ANIMATE = 0.1

  class Part1
    def run(input_file)
      puts
      lines = File.readlines(input_file, chomp: true)

      filled_v = Hash.new { |h,k| h[k] = [] }
      rocks = []

      h = lines.length
      w = lines[0].length

      lines.each_with_index do |l, y|
        l.split("").each_with_index do |c, x|
          if c == "#"
            filled_v[x] << y
          elsif c == "O"
            filled_v[x] << y
            rocks << [y,x]
          end
        end
      end

      display(h,w,filled_v,rocks)

      rocks = rocks.sort_by { |r| r[0] }

      rocks.each do |r|
        move_north(r, filled_v, rocks)
        display(h,w,filled_v,rocks)

      end

      display(h,w,filled_v,rocks)

      rocks.sum { |r| h - r[0] }
    end

    def move_north(rock, filled_v, rocks)
      current_y = rock[0]
      filled = filled_v[rock[1]]
      new_y = (filled.select { |f| f < current_y }.max || -1) + 1
      rock[0] = new_y
      filled_v[rock[1]].delete(current_y)
      filled_v[rock[1]] << new_y
      nil
    end

    def display(h, w, filled, rocks)
      return unless DEBUG

      (0...h).each do |y|
        out = ""
        (0...w).each do |x|
          if rocks.include?([y,x])
            out << "O"
          elsif filled[x].include?(y)
            out << "#"
          else
            out << "."
          end
        end
        puts out
      end
      puts

      print "\033[#{h+1}A"
      print "\r"
      sleep(ANIMATE)

    end
  end
end
