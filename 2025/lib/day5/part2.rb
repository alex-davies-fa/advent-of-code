require 'csv'
require 'pp'

module Day5
  class Part2
    def run(input_file)
      ranges_s, ingredients_s = File.read(input_file).split("\n\n")

      ranges = ranges_s.split("\n").map do |r|
        parts = r.strip.split("-").map(&:to_i)
        (parts[0]..parts[1])
      end

      fringe = ranges
      ranges = []

      while r1 = fringe.pop
        if ranges.empty?
          ranges << r1
          next
        end

        combined = false
        ranges.each do |r2|
          new_range = combine_ranges(r1, r2)
          if new_range
            ranges.delete(r2)
            fringe << new_range
            combined = true
            break
          end
        end
        ranges << r1 if !combined
      end

      ranges.sum { _1.size }
    end

    def combine_ranges(r1, r2)
      return false unless r1.overlap?(r2)

      [r1.begin,r2.begin].min..[r1.end,r2.end].max
    end
  end
end
