require 'csv'
require 'pp'

module Day14
  DDEBUG = true
  DANIMATE = 0.01

  class Part2
    def run(input_file)
      puts
      lines = File.readlines(input_file, chomp: true)

      filled_v = Hash.new { |h,k| h[k] = [] }
      filled_h = Hash.new { |h,k| h[k] = [] }
      rocks = []

      h = lines.length
      w = lines[0].length

      lines.each_with_index do |l, y|
        l.split("").each_with_index do |c, x|
          if c == "#"
            filled_v[x] << y
            filled_h[y] << x
          elsif c == "O"
            filled_v[x] << y
            filled_h[y] << x
            rocks << [y,x]
          end
        end
      end

      visited = Set.new
      visited_times = {}
      curr_cycle = 0
      repeat = false

      while true
        run_cycle(rocks, filled_v, filled_h, h, w)
        curr_cycle += 1

        if !visited.add?(filled_h)
          break
        end

        visited_times[filled_h] = curr_cycle
      end

      display(h,w,filled_v, filled_h, rocks)

      start = visited_times[filled_h]
      cycle_length = curr_cycle - start

      n = 1_000_000_000
      n_cycles = (n - start) / cycle_length
      rem = n - start - (cycle_length * n_cycles)
      # puts "#{start} + #{n_cycles} * #{cycle_length} + #{rem}"

      rem.times do
        run_cycle(rocks, filled_v, filled_h, h, w)
      end

      display(h,w,filled_v, filled_h, rocks)

      rocks.sum { |r| h - r[0] }
    end

    def run_cycle(rocks, filled_v, filled_h, h, w)
      rocks.sort_by! { |r| r[0] }
      rocks.each do |r|
        move_north(r, filled_v, filled_h)
      end
      display(h,w,filled_v, filled_h, rocks)

      rocks.sort_by! { |r| r[1] }
      rocks.each do |r|
        move_west(r, filled_v, filled_h)
      end
      display(h,w,filled_v, filled_h, rocks)

      rocks.sort_by! { |r| -r[0] }
      rocks.each do |r|
        move_south(r, filled_v, filled_h, h)
      end
      display(h,w,filled_v, filled_h, rocks)

      rocks.sort_by! { |r| -r[1] }
      rocks.each do |r|
        move_east(r, filled_v, filled_h, w)
      end
      display(h,w,filled_v, filled_h, rocks)
    end

    def move_north(rock, filled_v, filled_h)
      new_y = (filled_v[rock[1]].select { |f| f < rock[0] }.max || -1) + 1
      new_pos = [new_y, rock[1]]
      update(rock, new_pos, filled_v, filled_h)
    end

    def move_south(rock, filled_v, filled_h, h)
      new_y = (filled_v[rock[1]].select { |f| f > rock[0] }.min || h ) - 1
      new_pos = [new_y, rock[1]]
      update(rock, new_pos, filled_v, filled_h)
    end

    def move_west(rock, filled_v, filled_h)
      new_x = (filled_h[rock[0]].select { |f| f < rock[1] }.max || -1) + 1
      new_pos = [rock[0], new_x]
      update(rock, new_pos, filled_v, filled_h)
    end

    def move_east(rock, filled_v, filled_h, w)
      new_x = (filled_h[rock[0]].select { |f| f > rock[1] }.min || w) - 1
      new_pos = [rock[0], new_x]
      update(rock, new_pos, filled_v, filled_h)
    end

    def update(rock, new_pos, filled_v, filled_h)
      filled_v[rock[1]].delete(rock[0])
      filled_h[rock[0]].delete(rock[1])

      rock[0] = new_pos[0]
      rock[1] = new_pos[1]

      filled_v[rock[1]] << rock[0]
      filled_h[rock[0]] << rock[1]
    end

    def display(h, w, filled_v, filled_h, rocks)
      return unless DDEBUG

      (0...h).each do |y|
        out = ""
        (0...w).each do |x|
          if rocks.include?([y,x])
            out << "⚪"
          elsif filled_h[y].include?(x)
            out << "🟫"
          else
            out << "⬛"
          end
        end
        puts out
      end
      puts

      if DANIMATE
        print "\033[#{h+1}A"
        print "\r"
        sleep(ANIMATE)
      end

    end
  end
end
