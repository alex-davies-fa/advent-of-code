require 'csv'
require 'pp'

module Day11
  class Part2
    T = 75
    CACHE = {}

    def run(input_file)
      all_nums = File.read(input_file).strip.split
      all_nums.map { count_in_steps(_1, T) }.sum
    end

    def count_in_steps(n,t)
      return CACHE[[n,t]] if CACHE[[n,t]]
      return 1 if t == 0

      CACHE[[n,t]] = next_nums(n).map { count_in_steps(_1,t-1) }.sum
    end

    def next_nums(n)
      if n == '0'
        ['1']
      elsif (n.length % 2) == 0
        h = n.length/2
        [n[0..h-1],n[h..-1].to_i.to_s]
      else
        [(n.to_i * 2024).to_s]
      end
    end
  end
end
