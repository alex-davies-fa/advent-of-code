require 'csv'
require 'pp'
require 'matrix'

module Day17
  class Part2
    LEFT = -1
    RIGHT = 1

    ROCKS = [
      { ind: 0, all: [[0,0],[1,0],[2,0],[3,0]], left: [[0,0]], right: [[3,0]], bot: [[0,0],[1,0],[2,0],[3,0]]},
      { ind: 1, all: [[1,0],[1,1],[1,2],[0,1],[2,1]], left: [[1,0],[0,1],[1,2]], right: [[1,0],[2,1],[1,2]], bot: [[0,1],[1,0],[2,1]] },
      { ind: 2, all: [[0,0],[1,0],[2,0],[2,1],[2,2]], left: [[0,0],[2,1],[2,2]], right: [[2,0],[2,1],[2,2]], bot: [[0,0],[1,0],[2,0]] },
      { ind: 3, all: [[0,0],[0,1],[0,2],[0,3]], left: [[0,0],[0,1],[0,2],[0,3]], right: [[0,0],[0,1],[0,2],[0,3]], bot: [[0,0]] },
      { ind: 4, all: [[0,0],[1,0],[0,1],[1,1]], left: [[0,0],[0,1]], right: [[1,0],[1,1]], bot: [[0,0],[1,0]] },
    ]

    DRAW = true
    ANIMATE = 0.1

    COUNT = 1_000_000_000_000

    def run(input_file)
      @wind = File.read(input_file).strip.chars.map { |c| c == '<' ? LEFT : RIGHT }

      @wind_index = 0
      @rock_index = 0
      max_height = -1

      filled = {
        0 => Set.new([-1]),
        1 => Set.new([-1]),
        2 => Set.new([-1]),
        3 => Set.new([-1]),
        4 => Set.new([-1]),
        5 => Set.new([-1]),
        6 => Set.new([-1])
      }

      precomputed = precompute_first_moves

      seen = Set.new
      seen_map = {}
      heights = [nil]

      cycle_length = nil
      cycle_offset = nil

      for n in 1..COUNT do
        puts "#{(n*100.0/COUNT).round}%" if !DRAW && n % 100_000 == 0

        # Cull old filled spots
        if n % 1 == 0
          filled.keys.each { |k| filled[k] = Set.new(filled[k].select { |f| f > max_height - 100 }) }
        end

        rock = next_rock

        # Store the current state
        filled_norm = filled.flat_map { |x,ys| ys.map { |y| [x,max_height-y] } }
        state = [@rock_index, @wind_index, filled_norm]
        unseen = seen.add?(state)

        if unseen
          seen_map[state] = n # Store when we first saw this state
        else
          cycle_start = seen_map[state]
          cycle_length = n - cycle_start
          height_for_cycle = max_height - heights[cycle_start]
          cycles, end_steps = (COUNT-cycle_start).divmod(cycle_length)
          end_height = heights[cycle_start + end_steps] - heights[cycle_start]
          puts heights[cycle_start] + cycles*height_for_cycle + end_height + 1
          break
        end

        winds = [next_wind, next_wind, next_wind, next_wind]
        x_val = precomputed[rock[:ind]][winds[0]][winds[1]][winds[2]][winds[3]]
        p = [x_val, max_height+4-3]
        print_rock(rock,p,filled, max_height)

        while true do
          # Drop rock
          np = [p[0],p[1]-1]
          break if rock[:bot].any? { |r| filled[r[0]+np[0]].include?(r[1]+np[1]) }
          p = np

          print_rock(rock,p,filled, max_height)

          # Push rock
          wind = next_wind
          np = [p[0]+wind,p[1]]
          side = wind == LEFT ? :left : :right
          p = np if rock[side].none? { |r| r[0]+np[0] < 0 || r[0]+np[0] > 6  || filled[r[0]+np[0]].include?(r[1]+np[1]) }

          print_rock(rock,p,filled, max_height)
        end

        rock[:all].each do |r|
          xpos = r[0]+p[0]
          ypos = r[1]+p[1]
          max_height = ypos if ypos > max_height
          filled[xpos].add(ypos)
        end

        heights[n] = max_height

        print_rock(rock,p,filled, max_height)
      end

      nil
    end

    def precompute_first_moves
      precomputed = Hash.new {|h,k| h[k] = h.class.new(&h.default_proc) }
      [LEFT,RIGHT].repeated_permutation(4).each do |winds|
        ROCKS.each do |rock|
          x = 2
          (0..3).each do |i|
            nx = x+winds[i]
            side = winds[i] == LEFT ? :left : :right
            x = nx if rock[:all].none? { |r| r[0]+nx < 0 || r[0]+nx > 6 }
          end
          precomputed[rock[:ind]][winds[0]][winds[1]][winds[2]][winds[3]] = x
        end
      end
      precomputed
    end

    def print_rock(rock, p, filled, max_height)
      return unless DRAW
      max_x = 6
      y_range = 30
      min_y = max_height - 20

      rock = rock[:all].map { |r| [r[0]+p[0],r[1]+p[1]] }

      for y in (min_y+y_range).downto(min_y) do
        for x in 0.upto(max_x) do
          if filled[x].include?(y)
            print '🟫'
          elsif rock.include?([x,y])
            print('⬜')
          elsif y < -1
            # NOOP
          else
            print('⬛')
          end
        end
        print "\n"
      end
      puts

      if ANIMATE
        print "\033[#{y_range+4}A"
        print "\r"
        sleep(ANIMATE)
      end
    end

    def next_rock
      rock = ROCKS[@rock_index]
      @rock_index += 1
      @rock_index = 0 if @rock_index == ROCKS.length
      rock
    end

    def next_wind
      dir = @wind[@wind_index]
      @wind_index += 1
      if @wind_index == @wind.length
        @wind_index = 0
      end
      dir
    end
  end
end
