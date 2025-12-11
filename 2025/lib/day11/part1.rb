require 'csv'
require 'pp'

module Day11
  class Part1
    def run(input_file)
      lines = File.readlines(input_file)
      nodes = Hash.new { |h,k| h[k] = [] }
      lines.each do |l|
        start, out = l.chomp.split(": ")
        out.split(" ").each { |o| nodes[start] << o }
      end

      count_paths(nodes, "you", "out")
    end

    def count_paths(nodes, start, target)
      return 1 if start == target

      nodes[start].map do |n|
        count_paths(nodes, n, target)
      end.sum
    end
  end
end
