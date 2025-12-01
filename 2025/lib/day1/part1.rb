require 'csv'
require 'pp'

module Day1
  class Part1
    DIRMAP = { "L" => -1, "R" => 1 }

    def run(input_file)
      vals = File.readlines(input_file).map { [DIRMAP[_1[0]], _1[1..].to_i] }

      curr = 50

      vals
        .map { |dir, val| curr = (curr + dir * val) % 100 }
        .count { _1 == 0  }
    end
  end
end
