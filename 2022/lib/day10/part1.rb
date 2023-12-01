require 'csv'
require 'pp'

module Day10
  class Part1
    def run(input_file)
      lines = File.readlines(input_file)

      cycle = 0
      register = [1]

      lines.each do |line|
        cmd, arg = line.split
        case cmd
        when "addx"
          puts "ADD #{arg}"
          cycle += 1
          register[cycle] = register[cycle-1]
          puts "#{cycle}: #{register[cycle]}"

          cycle += 1
          register[cycle] = register[cycle-1] + arg.to_i
          puts "#{cycle}: #{register[cycle]}"
          puts
        when "noop"
          cycle += 1
          register[cycle] = register[cycle-1]
          puts "#{cycle}: #{register[cycle]}"
          puts
        end
      end

      puts

      offset = 20
      step = 40
      cycles = register.length

      strengths =
        (0..cycles-offset).step(40).map do |i|
          cycle = i + 20
          puts "#{cycle}: #{register[cycle-1]}"
          cycle * register[cycle-1]
        end

      puts strengths.sum

      nil
    end
  end
end
