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

      display = (1..HEIGHT).map { ['⬛'] * WIDTH }

      lines.each do |line|
        cmd, arg = line.split
        case cmd
        when "addx"
          cycle += 1
          register[cycle] = register[cycle-1]
          mark(display, cycle, register[cycle-1])

          cycle += 1
          register[cycle] = register[cycle-1] + arg.to_i
          mark(display, cycle, register[cycle-1])
        when "noop"
          cycle += 1
          register[cycle] = register[cycle-1]
          mark(display, cycle, register[cycle-1])
        end
      end

      draw_sprite(register.last)
      draw(display)

      nil
    end

    def mark(display, cycle, register)
      x = (cycle - 1) % 40
      y = (cycle - 1) / 40

      mark_cell = (register - x).abs <= 1
      display[y][x] = '⬜' if mark_cell

      cursor_val = display[y][x]
      display[y][x] = mark_cell ? '🟥' : '🟦'
      draw_sprite(register)
      draw(display)
      sleep(0.1)
      puts "\033[9A"
      puts "\r"
      display[y][x] = cursor_val
    end

    def draw_sprite(register)
      line = ["⬛"] * 40
      x = register
      line[x] = '🟥'
      line[x-1] = '🟥' unless x == 0
      line[x+1] = '🟥' unless x == 39
      puts line.join
    end

    def draw(display)
      display.each do |line|
        puts line.join
      end
    end
  end
end
