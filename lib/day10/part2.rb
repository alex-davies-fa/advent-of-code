require 'csv'
require 'pp'

module Day10
  class Part2
    WIDTH = 40
    HEIGHT = 6

    def run(input_file)
      lines = File.readlines(input_file)

      cycle = 0
      register = [1]

      display = (1..HEIGHT).map { ['.'] * WIDTH }

      lines.each do |line|
        cmd, arg = line.split
        case cmd
        when "addx"
          cycle += 1
          register[cycle] = register[cycle-1]
          mark(display, cycle, register[cycle])

          cycle += 1
          register[cycle] = register[cycle-1] + arg.to_i
          mark(display, cycle, register[cycle])
        when "noop"
          cycle += 1
          register[cycle] = register[cycle-1]
          mark(display, cycle, register[cycle])
        end
      end

      draw(display)

      nil
    end

    def mark(display, cycle, register)
      x = (cycle - 1) % 40
      y = (cycle - 1) / 40

      if (register - (x+1)).abs <= 1
        display[y][x] = '#'
      end
    end

    def draw(display)
      display.each do |line|
        puts line.join
      end
    end
  end
end
