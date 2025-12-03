require 'csv'
require 'pp'

module Day3
  class Part2
    N = 12

    def run(input_file)
      banks = File.readlines(input_file).map { _1.strip.chars.map(&:to_i) }

      banks.sum do |bank|
        (1..N).to_a.reverse.sum do |n|
          max = bank[..-n].max
          bank = bank[bank.find_index(max)+1..]
          max * 10**(n-1)
        end
      end
    end
  end
end
