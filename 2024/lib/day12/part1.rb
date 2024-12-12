require 'csv'
require 'pp'

module Day12
  class Part1
    DIRS = [
      [-1,0],
      [1,0],
      [0,1],
      [0,-1],
    ]

    def run(input_file)
      data = File.readlines(input_file)
      garden = Hash.new
      data.each_with_index do |l,y|
        l.strip.chars.each_with_index do |c,x|
          garden[[y,x]] = c
        end
      end

      pp garden

      out = 0
      while garden.keys.any?
        p = garden.keys.first
        c = garden.delete(p)
        fringe = [p]
        area = Set.new(fringe)
        perim = Set.new
        while p = fringe.pop 
          DIRS.each do |d|
            p2 = add(p,d)
            if garden[p2] == c && !area.include?(p2)
              fringe.push(p2)
              garden.delete(p2)
              area.add(p2)
            else
              perim.add([p,p2].sort) unless area.include?(p) && area.include?(p2)
            end
          end
        end
        pp perim, area
        out += perim.length*area.length
      end

      out
    end

    def add(a,b)
      [a[0]+b[0],a[1]+b[1]]
    end
  end
end
