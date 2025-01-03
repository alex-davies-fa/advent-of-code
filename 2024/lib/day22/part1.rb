require 'csv'
require 'pp'

module Day22
  class Part1
    N = 2000

    def run(input_file)
      initial_nums = File.readlines(input_file).map(&:to_i)

      seq_vals = []
      seq_scores = Hash.new(0)
      initial_nums.each_with_index do |n,i|
        costs = get_costs(n)
        diffs = costs.each_cons(2).map { _2 - _1 }
        seq_vals(diffs.each_cons(4),costs,seq_scores)
      end

      seq_scores.values.max
    end

    def seq_vals(seqs,costs,all_seqs)
      visited = Set.new
      seqs.each_with_index do |seq, i|
        next if visited.include?(seq)
        visited.add(seq)
        all_seqs[seq] = all_seqs[seq] + costs[i+4]
      end
    end

    def get_costs(n)
      costs = [n % 10]
      N.times do
        n = next_number(n)
        costs << n % 10
      end
      costs
    end

    def next_number(n)
      # Calculate the result of multiplying the secret number by 64. Then, mix this result into the secret number. Finally, prune the secret number.
      n = prune(mix(n * 64,n))
      # Calculate the result of dividing the secret number by 32. Round the result down to the nearest integer. Then, mix this result into the secret number. Finally, prune the secret number.
      n = prune(mix((n/32.0).truncate,n))
      # Calculate the result of multiplying the secret number by 2048. Then, mix this result into the secret number. Finally, prune the secret number.
      n = prune(mix(n * 2048,n))
    end

    # To mix a value into the secret number, calculate the bitwise XOR of the given value and the secret number. Then, the secret number becomes the result of that operation. (If the secret number is 42 and you were to mix 15 into the secret number, the secret number would become 37.)
    def mix(a,b)
      a ^ b
    end
    
    # To prune the secret number, calculate the value of the secret number modulo 16777216. Then, the secret number becomes the result of that operation. (If the secret number is 100000000 and you were to prune the secret number, the secret number would become 16113920.)
    def prune(n)
      n % 16777216
    end
  end
end
