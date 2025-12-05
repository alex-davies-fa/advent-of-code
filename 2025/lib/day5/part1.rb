require 'csv'
require 'pp'

module Day5
  class Part1
    def run(input_file)
      ranges_s, ingredients_s = File.read(input_file).split("\n\n")

      ranges = ranges_s.split("\n").map do |r|
        parts = r.strip.split("-").map(&:to_i)
        (parts[0]..parts[1])
      end
      ingredients = ingredients_s.split("\n").map { _1.strip.to_i }

      ingredients.count { |i| ranges.any? { |r| r.include?(i) } }
    end
  end
end
