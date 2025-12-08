require 'csv'
require 'pp'

module Day3
  class Part3
    N = 12

    def run(input_file)
      banks = File.readlines(input_file).map { _1.strip.chars.map(&:to_i) }

      banks.sum do |bank|
        max_joltage(bank, 0, N)
      end
    end

    def max_joltage(bank, pos, remaining, cache = {})
      return 0 if remaining == 0
      return -1*10**N if pos == bank.length 

      key = [pos, remaining]
      return cache[key] if cache[key]
      
      option_1 = max_joltage(bank, pos+1, remaining, cache)
      option_2 = bank[pos]*(10**(remaining-1)) + max_joltage(bank, pos+1, remaining-1, cache)

      cache[key] = [option_1, option_2].max
    end
  end
end
