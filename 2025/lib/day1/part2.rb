require 'csv'
require 'pp'

module Day1
  class Part2
    def run(input_file)
      lines = File.readlines(input_file)
      vals = lines.map { [_1[0], _1[1..].to_i] }

      curr = 50
      count = 0

      vals.each do |dir, val|
        count += val / 100
        val = val % 100

        prev = curr
        if dir == "L"
          curr -= val
        else
          curr += val
        end

        if curr <= 0 || curr >= 100
          count += 1 unless prev == 0
        end

        curr = curr % 100
      end


      count
    end
  end
end
