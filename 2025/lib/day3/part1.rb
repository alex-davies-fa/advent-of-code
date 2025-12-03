require 'csv'
require 'pp'

module Day3
  class Part1
    def run(input_file)
      banks = File.readlines(input_file).map { _1.strip.chars.map(&:to_i) }
      out = 0

      banks.each do |bank|
        max = bank[..-2].max
        max_ind = bank.find_index(max)
        next_max = bank[max_ind+1..].max
        out += max*10 + next_max
      end

      out
    end
  end
end
