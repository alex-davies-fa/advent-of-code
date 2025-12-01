require 'csv'
require 'pp'

module Day1
  class Part1
    def run(input_file)
      lines = File.readlines(input_file)
      vals = lines.map { [_1[0], _1[1..].to_i] }

      curr = 50
      count = 0

      vals.each do |dir, val|
        if dir == "L"
          curr -= val
        else
          curr += val
        end
        curr = curr % 100
        count += 1 if curr == 0
      end

      count
    end
  end
end
