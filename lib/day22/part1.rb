require 'csv'
require 'pp'

module Day22
  class Part1
    DIRS = [[0,1], [1,0], [0,-1], [-1,0]]

    DIR_OUT = {
      [0,-1] => "<",
      [0,1] => ">",
      [1,0] => "v",
      [-1,0] => "^",
    }

    PRINT = true

    def run(input_file)
      map, instructions = read_input(input_file)
      output_map = map.map { |r| r.clone }

      dir = DIRS[0]

      pos = [0, map[0].find_index { |v| v != " " }]

      for i in instructions
        case i
        when String
          dir = turn(dir, i)
          output_map[pos[0]][pos[1]] = DIR_OUT[dir]
          print_map(output_map, pos)
        when Integer
          i.times do
            pos = step(map, pos, dir)
            output_map[pos[0]][pos[1]] = DIR_OUT[dir]
            print_map(output_map, pos)
          end
        end
      end

      pp pos[0] + 1, pos[1] + 1, DIRS.find_index(dir)
      pp 1000 * (pos[0]+1) + 4*(pos[1]+1) + DIRS.find_index(dir)

      nil
    end

    def turn(dir, instruction)
      di = DIRS.find_index(dir)
      d = instruction == "L" ? -1 : 1
      di = (di+d) % DIRS.length
      DIRS[di]
    end

    def step(map, pos, dir)
      w = map[0].length - 1
      h = map.length - 1

      new_pos = [pos[0] + dir[0], pos[1] + dir[1]]

      new_pos[0] = h if new_pos[0] < 0
      new_pos[0] = 0 if new_pos[0] > h
      new_pos[1] = w if new_pos[1] < 0
      new_pos[1] = 0 if new_pos[1] > w

      return new_pos if map[new_pos[0]][new_pos[1]] == "."
      return pos if map[new_pos[0]][new_pos[1]] == "#"

      # Otherwise hit a "warp"
      next_step = step(map, new_pos, dir)
      next_step == new_pos ? pos : next_step
    end

    def read_input(file)
      map,instructions = File.read(file).split("\n\n")

      map = map.split("\n")
      max_width = map.map(&:length).max
      map = map.map { |l| l.ljust(max_width, " ") }.map(&:chars)

      instructions = instructions.strip.split(/(L|R)/)
      instructions.map! { |i| i =~ /L|R/ ? i : i.to_i }

      [map, instructions]
    end

    def print_map(map, pos)
      return unless PRINT

      s = 10
      left = pos[1] - s
      right = pos[1] + s
      top = pos[0] - s
      bot = pos[0] + s

      sub = {
        " " => "⬜",
        "." => "⬛",
        "#" => "🟫",
        "<" => "⬅ ",
        ">" => "➜ ",
        "v" => "⬇ ",
        "^" => "⬆ ",
        nil => "⬜"
      }
      (top..bot).each do |y|
        (left..right).each do |x|
          if y < 0 || y >= map.length || x < 0 || x >= map[0].length
            print "⬜"
          else
            print sub[map[y][x]]
          end
        end
        print "\n"
      end

      print "\033[#{s*2+1}A"
      print "\r"

      sleep(0.05)
    end
  end
end
