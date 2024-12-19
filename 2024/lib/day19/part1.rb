require 'csv'
require 'pp'

module Day19
  class Part1
    def run(input_file)
      ts, ps = File.read(input_file).split("\n\n")
      towels = ts.strip.split(",").map(&:strip)
      patterns = ps.split("\n")

      count = 0
      patterns.each do |pattern|
        count += 1 if can_match?(pattern, towels)
      end

      count
    end

    def can_match?(pattern, towels, visited = Set.new)
      return true if pattern.length == 0

      matches = towels.filter { |t| pattern.start_with?(t) }

      matches.any? do |m|
        new_pattern = pattern[m.length..-1]
        next unless visited.add?(new_pattern)
        can_match?(new_pattern, towels, visited)
      end
    end
  end
end
