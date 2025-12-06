require 'csv'
require 'pp'

module Day6
  class Part1
    def run(input_file)
      lines = File.readlines(input_file)
      nums = lines[..-2].map { |l| l.split.map(&:to_i) }.transpose
      ops = lines[-1].split

      (0...ops.length).sum do |i|
        if ops[i] == "+"
          nums[i].sum
        else
          nums[i].inject(&:*)
        end
      end
    end
  end
end
