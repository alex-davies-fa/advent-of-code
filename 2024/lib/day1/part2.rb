require 'csv'
require 'pp'

module Day1
  class Part2
    def run(input_file)
      data = File.readlines(input_file).map(&:split).transpose

      rightTally = data[1].tally
      rightTally.default = 0
      data[0].map { _1.to_i * rightTally[_1]}.sum
    end
  end
end
