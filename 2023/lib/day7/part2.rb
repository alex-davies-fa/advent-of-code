require 'csv'
require 'pp'

module Day7
  class Part2
    HAND_VALS = {
      "5" => 7,
      "41" => 6,
      "32" => 5,
      "311" => 4,
      "221" => 3,
      "2111" => 2,
      "11111" => 1,
    }

    J_VALS = (2..9).to_a.map(&:to_s) + ["T","Q","K","A"]

    def run(input_file)
      lines = File.readlines(input_file)

      hands = lines.map do |line|
        hand, bid = line.split(" ")

        type_score = J_VALS.map do |j|
          new_hand = hand.gsub("J",j)
          type = new_hand.split("").tally.values.sort.reverse.map(&:to_s).inject(:+)
          HAND_VALS[type]
        end.max

        vals = hand.split("").map do
          _1.gsub("T","10").gsub("J","1").gsub("Q","12").gsub("K","13").gsub("A","14").to_i
        end

        { type_score: , vals: , bid: }
      end

      ordered_hands = hands.sort_by { |h| [h[:type_score]] + h[:vals] }

      ordered_hands.map.with_index do |h, i|
        h[:bid].to_i * (i+1)
      end.sum
    end
  end
end
