require 'csv'
require 'pp'

module Day3
  class Part2
    def run(input_file)
      input = File.read(input_file)
      commands = input.scan(/(mul|don't|do)\(([\d\,]*)\)/)

      sum = 0
      enabled = 1

      commands.each do |c, args|
        case c
        when "do"
          enabled = 1
        when "don't"
          enabled = 0
        when "mul"
          arg1, arg2 = args.split(",").map(&:to_i)
          sum += arg1 * arg2 * enabled
        end
      end
      
      sum
    end
  end
end
