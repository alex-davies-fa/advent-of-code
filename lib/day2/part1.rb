require 'csv'
require 'pp'

module Day2
  class Part1
    SCORES = {
      "X" => 1,
      "Y" => 2,
      "Z" => 3,
    }

    T = {
      "A" => 0,
      "B" => 1,
      "C" => 2,
      "X" => 0,
      "Y" => 1,
      "Z" => 2,
    }

    def run(input_file)
      rounds = CSV.read(input_file, col_sep: " ")
      rounds
        .map { |round| total_for_round(round[0], round[1]) }
        .sum
    end

    def total_for_round(them, us)
      score_for_round(them, us) + score_for_pick(us)
    end

    def score_for_round(them, us)
      them_val = T[them]
      us_val = T[us]

      return 3 if them_val == us_val # Draw
      return 6 if (them_val+1)%3 == us_val # We win
      return 0 # They win
    end

    def score_for_pick(us)
      SCORES[us]
    end
  end
end
