require 'csv'
require 'pp'
require 'set'

module Day4
  class Part1
    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      cards = lines.map do |line|
        winners, numbers =
          line.split(":")[1]
            .split("|")
            .map { _1.scan(/\d+/) }
            .map { _1.map(&:to_i) }
        [ Set.new(winners), Set.new(numbers) ]
      end

      total = cards.sum do |winners, numbers|
        overlap = (winners & numbers).length
        overlap > 0 ? 2**(overlap-1) : 0
      end

      total
    end
  end
end
