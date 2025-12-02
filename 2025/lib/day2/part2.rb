require 'csv'
require 'pp'

module Day2
  class Part2
    def run(input_file)
      raw = File.read(input_file)
      ranges = raw.split(",").map { _1.split("-").map(&:to_i) }

      out = 0

      ranges.each do |i, j|
        (i..j).each do |n|
          str = n.to_s
          out += n if prefixes(str).any? { is_repeat?(str, _1) }
        end
      end

      out
    end

    def is_repeat?(str,seg)
      str.scan(seg).sum(&:length) == str.length
    end

    def prefixes(str)
      (0...str.size/2).map do |i|
        str[0..i]
      end
    end
  end
end
