require 'csv'
require 'pp'

module Day15
  class Part1
    def run(input_file)
      input = File.read(input_file).strip

      input.split(",").map { hash(_1) }.sum
    end

    def hash(s)
      s.chars.inject(0) { |val, c| (val + c.ord) * 17 % 256 }
    end
  end
end
