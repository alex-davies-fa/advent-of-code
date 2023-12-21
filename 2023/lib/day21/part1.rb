require 'csv'
require 'pp'

module Day21
  class Part1
    DIRS = [-1,0,1].permutation(2).filter { _1.map(&:abs).sum == 1 }

    def run(input_file)
      lines = File.readlines(input_file, chomp: true)

      start, rocks, yr, xr = parse_input(lines)

      fringe = [start]
      visited = Set.new

      64.times do
        new_fringe = Set.new
        fringe.each do |p|
          neighbours(p,rocks,yr,xr).each { new_fringe.add(_1) }
        end
        fringe = new_fringe
      end

      fringe.length
    end

    def neighbours(p,rocks,yr,xr)
      ns = DIRS.map { add(_1,p) }
      ns.filter { |y,x| !rocks.include?([y,x]) && yr.include?(y) && xr.include?(x) }
    end

    def add(a,b)
      [a[0]+b[0],a[1]+b[1]]
    end

    def parse_input(lines)
      rocks = Set.new
      start = nil

      lines.each_with_index do |l, y|
        l.split("").each_with_index do |c, x|
          if c == "#"
            rocks.add([y,x])
          elsif c == "S"
            start = [y,x]
          end
        end
      end

      [start, rocks, (0...lines.length), (0...lines[0].length)]
    end
  end
end
