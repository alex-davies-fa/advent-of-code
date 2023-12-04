require 'csv'
require 'pp'
require 'set'

module Day4
  class Part2
    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      cards = lines.map do |line|
        winners, numbers =
          line.split(":")[1]
            .split("|")
            .map { _1.scan(/\d+/) }
            .map { _1.map(&:to_i) }
        {
          winners: Set.new(winners),
          numbers: Set.new(numbers),
          count: 1
        }
      end

      cards.each_with_index do |card, i|
        overlap = (card[:winners] & card[:numbers]).length
        (i+1...i+1+overlap).each do |j|
          cards[j][:count] += card[:count]
        end

      end

      cards.sum { |c| c[:count] }
    end
  end
end
