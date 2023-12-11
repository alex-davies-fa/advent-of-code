require 'csv'
require 'pp'

module Day11
  class Part1
    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      empty_rows = (0...lines.length).to_a.to_set
      empty_cols = (0...lines[0].length).to_a.to_set

      gs = []

      lines.each_with_index do |l,y|
        l.split('').each_with_index do |c,x|
          if c == '#'
            empty_cols.delete(x)
            empty_rows.delete(y)
            gs << [y,x]
          end
        end
      end

      # Expand
      empty_rows.to_a.sort.reverse.each do |r|
        gs = gs.map { |g| g[0] > r ? [g[0]+1, g[1]] : g }
      end

      empty_cols.to_a.sort.reverse.each do |c|
        gs = gs.map { |g| g[1] > c ? [g[0], g[1]+1] : g }
      end

      # Find paths
      gs.combination(2).sum do |g1,g2|
        dist = (g2[0] - g1[0]).abs + (g2[1] - g1[1]).abs
      end
    end
  end
end
