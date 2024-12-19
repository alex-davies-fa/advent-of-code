require 'csv'
require 'pp'

module Day19
  class Part2
    def run(input_file)
      ts, ps = File.read(input_file).split("\n\n")
      towels = ts.strip.split(",").map(&:strip)
      patterns = ps.split("\n")

      count = 0
      patterns.each do |pattern|
        visited = Hash.new { |h,k| h[k] = [] }
        matches(pattern, towels, visited)

        next unless visited.key?("")
        count += paths("",visited)
      end

      count
    end

    def paths(node, tree, counts = {})
      return 1 if !tree.key?(node)
      return counts[node] if counts.key?(node)

      branches = tree[node]
      counts[node] = branches.sum { |b| paths(b,tree,counts) }
    end

    def matches(pattern, towels, visited)      
      matches = towels.filter { |t| pattern.start_with?(t) }

      matches.each do |m|
        new_pattern = pattern[m.length..-1]

        if visited.key?(new_pattern)
          visited[new_pattern] << pattern
        else
          visited[new_pattern] = [pattern]
          next if new_pattern.empty?
          matches(new_pattern, towels, visited)
        end
      end
    end
  end
end
