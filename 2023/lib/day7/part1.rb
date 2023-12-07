require 'csv'
require 'pp'

module Day7
  class Part1
    VALS = {
      "5" => 7,
      "41" => 6,
      "32" => 5,
      "311" => 4,
      "221" => 3,
      "2111" => 2,
      "11111" => 1,
    }

    def run(input_file)
      lines = File.readlines(input_file)

      hands = lines.map do |line|
        hand, bid = line.split(" ")
        type = hand.split("").tally.values.sort.reverse.map(&:to_s).inject(:+)
        vals = hand.split("").map do
          _1.gsub("T","10").gsub("J","11").gsub("Q","12").gsub("K","13").gsub("A","14").to_i
        end
        { type: , vals: , bid: }
      end

      ordered_hands = hands.sort_by { |h| [VALS[h[:type]]] + h[:vals] }

      ordered_hands.map.with_index do |h, i|
        h[:bid].to_i * (i+1)
      end.sum
    end
  end
end
