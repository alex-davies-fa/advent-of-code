require 'csv'
require 'pp'

module Day2
  class Part1
    def run(input_file)
      raw = File.read(input_file)
      ranges = raw.split(",").map { _1.split("-").map(&:to_i) }

      out = 0

      ranges.each do |i, j|
        (i..j).each do |n|
          str = n.to_s
          size = str.length
          out += n if str[0...size/2] == str[size/2..]
        end
      end

      out
    end
  end
end
