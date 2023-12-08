require 'csv'
require 'pp'

module Day8
  class Part1
    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      dirs = lines[0].split('').map { _1 == 'L' ? 0 : 1 }
      nodes = lines[2..].map do |line|
        node, left, right = line.scan(/[A-Z]+/)
        [node, [left, right]]
      end.to_h

      steps = 0
      node = "AAA"

      while true
        dirs.each do |d|
          steps += 1
          node = nodes[node][d]
          return steps if node == "ZZZ"
        end
      end
    end
  end
end
