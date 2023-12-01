require 'csv'
require 'pp'

module Day2
  class Part2
    SCORES = {
      "A" => 1,
      "B" => 2,
      "C" => 3,
    }

    T = {
      "A" => 0,
      "B" => 1,
      "C" => 2,
    }

    DESIRED_SCORE = {
      "X" => 0,
      "Y" => 3,
      "Z" => 6,
    }

    def run(input_file)
      rounds = CSV.read(input_file, col_sep: " ")
      rounds
        .map { |round| get_inputs(round[0], round[1]) }
        .map { |choices| total_for_round(choices[0], choices[1]) }
        .sum
    end

    def get_inputs(them, desired)
      our_input = get_our_input(them, desired)
      [them, our_input]
    end

    def get_our_input(them, desired)
      ["A","B","C"].detect do |us|
        score_for_round(them, us) == DESIRED_SCORE[desired]
      end
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
