require 'csv'
require 'pp'

module Day3
  class Part1
    def run(input_file)
      input = File.read(input_file)
      nums = input.scan(/mul\((\d+)\,(\d+)\)/)
      nums.map { |a,b| a.to_i * b.to_i }.sum
    end
  end
end
