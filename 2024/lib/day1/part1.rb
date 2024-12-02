require 'csv'
require 'pp'

module Day1
  class Part1
    def run(input_file)
      data = File.readlines(input_file).map(&:split).transpose
      data.each(&:sort!)

      data.transpose.map { |a,b| (a.to_i - b.to_i).abs}.sum
    end
  end
end
