require 'csv'
require 'pp'

module Day25
  class Part1
    CHAR_MAP = {
      '0' => 0,
      '1' => 1,
      '2' => 2,
      '-' => -1,
      '=' => -2
    }

    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      snafus = lines.map { |line| line.chars.map { |c| CHAR_MAP[c] }.reverse }

      vals = snafus.map { to_dec(_1) }

      total = vals.sum

      pp total

      base_5 = total.to_s(5).chars.map(&:to_i).reverse
      pp base_5

      nil
    end

    def to_dec(snafu)
      snafu.each_with_index.inject(0) { |sum, (v,i)| sum + v*5**i}
    end

    def max_with_digits(n)
      (0..n-1).inject(0) { |sum, i| sum + 2*5**i }
    end
  end
end
