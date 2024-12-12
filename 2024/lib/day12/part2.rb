require 'csv'
require 'pp'

module Day12
  class Part2
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

        # pp [sides(perim,area),area.length]
        out += sides(perim,area)*area.length
      end

      out
    end

    def sides(perim,area)
      count = 0
      
      while perim.any?
        count += 1
        e = perim.first
        perim.delete(e)
        fringe = [e]
        while e = fringe.pop
          adj = adjacent_edges(e)
          adj.each do |a|
            next unless area.include?(e[0]) && area.include?(a[0]) || area.include?(e[1]) && area.include?(a[1])
            fringe << a if perim.delete?(a)
          end
        end
      end

      count
    end

    def adjacent_edges(e)
      p1,p2 = e
      dirs = 
        if p1[0] == p2[0]
          [[1,0],[-1,0]]
        else
          [[0,1],[0,-1]]
        end
      dirs.map { |d| e.map { add(_1,d) } }
    end

    def add(a,b)
      [a[0]+b[0],a[1]+b[1]]
    end
  end
end
