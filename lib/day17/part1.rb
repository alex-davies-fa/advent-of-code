require 'csv'
require 'pp'
require 'matrix'

module Day17
  class Part1
    LEFT = -1
    RIGHT = 1

    ROCKS = [
      [[0,0],[1,0],[2,0],[3,0]],
      [[1,0],[1,1],[1,2],[0,1],[1,1],[2,1]],
      [[0,0],[1,0],[2,0],[2,1],[2,2]],
      [[0,0],[0,1],[0,2],[0,3]],
      [[0,0],[1,0],[0,1],[1,1]],
    ]

    ANIMATE = true

    COUNT = 2022

    def run(input_file)
      @wind = File.read(input_file).strip.chars

      @wind_index = 0
      @rock_index = 0
      max_height = -1

      filled = Set.new

      for n in 1..COUNT do
        rock = next_rock
        p = [2,max_height+4]

        print_rock(rock, p, filled)

        while true do
          # Push rock
          np = [p[0]+next_wind,p[1]]
          p = np if rock.none? { |r| r[0]+np[0] < 0 || r[0]+np[0] > 6  || filled.include?([r[0]+np[0],r[1]+np[1]]) }

          print_rock(rock, p, filled)

          # Drop rock
          np = [p[0],p[1]-1]
          break if rock.any? { |r| r[1]+np[1] < 0 || filled.include?([r[0]+np[0],r[1]+np[1]]) }
          p = np
        end

        rock.each { |r| filled.add([r[0]+p[0], r[1]+p[1]]) }

        max_height = filled.map{ _1[1] }.max
      end

      puts max_height + 1
      nil
    end

    def print_rock(rock, p, filled)
      max_x = 6
      max_y = 30

      rock = rock.map { |r| [r[0]+p[0],r[1]+p[1]] }

      for y in max_y.downto(0) do
        for x in 0.upto(max_x) do
          if filled.include?([x,y])
            print '🟫'
          else
            rock.include?([x,y]) ? print('⬜') : print('⬛')
          end
        end
        print "\n"
      end
      puts

      if ANIMATE
        print "\033[#{max_y+2}A"
        print "\r"
        sleep(0.3)
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
