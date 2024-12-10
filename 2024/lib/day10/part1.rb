require 'csv'
require 'pp'

module Day10
  class Part1
    DIRS = [
      [-1,0],
      [1,0],
      [0,1],
      [0,-1],
    ]

    def run(input_file)
      data = File.readlines(input_file)
      map = Hash.new(-1)
      data.each_with_index do |l,y|
        l.strip.chars.each_with_index do |c,x|
          map[[y,x]] = c.to_i
        end
      end

      trailheads = map.filter { |k,v| v == 0 }.map(&:first)
      fringe = trailheads.map { [[_1],0] }
      trails = []

      while fringe.any?
        path, h = fringe.pop

        if h == 9
          trails << path
          next
        end

        DIRS.each do |d|
          p2 = add(d,path.last)
          next unless map[p2] == h+1
          fringe.push([path.dup << p2,h+1])
        end
      end
      
      trails.map { [_1.first, _1.last] }.uniq.length
    end

    def add(a,b)
      [a[0]+b[0],a[1]+b[1]]
    end
  end
end
