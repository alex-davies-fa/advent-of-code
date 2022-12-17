require 'csv'
require 'pp'
require 'matrix'

module Day17
  class Part2
    LEFT = -1
    RIGHT = 1

    ROCKS = [
      { all: [[0,0],[1,0],[2,0],[3,0]], left: [[0,0]], right: [[3,0]], bot: [[0,0],[1,0],[2,0],[3,0]]},
      { all: [[1,0],[1,1],[1,2],[0,1],[1,1],[2,1]], left: [[1,0],[0,1],[1,2]], right: [[1,0],[2,1],[1,2]], bot: [[0,1],[1,0],[2,1]] },
      { all: [[0,0],[1,0],[2,0],[2,1],[2,2]], left: [[0,0],[2,1],[2,2]], right: [[2,0],[2,1],[2,2]], bot: [[0,0],[1,0],[2,0]] },
      { all: [[0,0],[0,1],[0,2],[0,3]], left: [[0,0],[0,1],[0,2],[0,3]], right: [[0,0],[0,1],[0,2],[0,3]], bot: [[0,0]] },
      { all: [[0,0],[1,0],[0,1],[1,1]], left: [[0,0],[0,1]], right: [[1,0],[1,1]], bot: [[0,0],[1,0]] },
    ]

    DRAW = false
    ANIMATE = true

    COUNT = 10_000

    def run(input_file)
      @wind = File.read(input_file).strip.chars

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

      precomputed = {}

      for n in 1..COUNT do
        # Cull old filled spots
        if n % 100 == 0
          filled.keys.each { |k| filled[k] = Set.new(filled[k].select { |f| f > max_height - 100 }) }
        end

        rock = next_rock
        p = [2,max_height+4]

        print_rock(rock,p,filled, max_height)

        winds = [next_wind, next_wind, next_wind, next_wind]
        if precomputed.key?([@rock_index, winds])
          p = [precomputed[[@rock_index, winds]], p[1]-3]
          print_rock(rock,p,filled, max_height)
        else
          x = p[0]
          (0..3).each do |i|
            nx = x+winds[i]
            side = winds[i] == LEFT ? :left : :right
            x = nx if rock[:all].none? { |r| r[0]+nx < 0 || r[0]+nx > 6 }
          end
          p = [x, p[1]-3]
          precomputed[[@rock_index, winds]] = x
          # pp precomputed
        end

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

        print_rock(rock,p,filled, max_height)
      end

      puts max_height + 1
      nil
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
          elsif y == -1
            print '🟫'
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
        print "\033[#{y_range+2}A"
        print "\r"
        sleep(0.05)
      end
    end

    def next_rock
      rock = ROCKS[@rock_index].clone
      @rock_index = (@rock_index + 1) % ROCKS.length
      rock
    end

    def next_wind
      dir =
        if @wind[@wind_index] == '>'
          RIGHT
        elsif @wind[@wind_index] == '<'
          LEFT
        else
          raise "BAD WIND"
        end
      @wind_index = (@wind_index + 1) % @wind.length
      dir
    end
  end
end
