require 'csv'
require 'pp'

module Day6
  class Part1
    def run(input_file)
      lines = File.readlines(input_file)
      times, distances = lines.map { |line| line.scan(/\d+/).map(&:to_i) }

      ranges = times.zip(distances).map do |t,d|
        p1 = t / 2.0
        p2 = Math.sqrt(t**2 - 4*d)/-2.0
        lower_root, upper_root = [p1 + p2, p1 - p2].sort
        lower_root = lower_root.ceil == lower_root ? lower_root.to_i + 1 : lower_root.ceil
        upper_root = upper_root.floor == upper_root ? upper_root.to_i - 1 : upper_root.floor
        upper_root - lower_root + 1
      end

      pp ranges.inject(:*)
      nil
    end
  end
end
