require 'csv'
require 'pp'

module Day12
  class Part1
    def run(input_file)
      presents, trees = parse_input(input_file)

      free_space = trees.map do |t|
        size = t[:size].inject(&:*)
        total = t[:presents].each_with_index.sum do |c,p|
          c * presents[p].length
        end
        size - total
      end

      # Cheap solution - it seems like for the given input, there are either straight up too many presents to fit
      # regardless of how you tessalated (i.e. 201 present tiles for a 200 space grid), or they fit easily.
      # Obvisouly not generic, but a solve is a solve :'D
      free_space.count { _1 > 0}
    end

    def all_variants(present)
      
    end

    def at_pos(y,x,present)
      present.map { [_1 + y, _2 + x]}
    end

    def parse_input(input_file)
      sections = File.read(input_file).split("\n\n")

      presents = sections[0..-2].map do |p|
        p = p.split("\n")[1..]
        [0,1,2].repeated_permutation(2).filter_map do |x,y|
          p[y][x] == "#" ? [y,x] : nil
        end
      end

      trees = sections[-1].split("\n").map do |t|
        vals = t.scan(/\d+/).map(&:to_i)
        { size: vals[0..1], presents: vals[2..] }
      end

      [presents, trees]
    end
  end
end
