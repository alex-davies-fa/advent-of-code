require 'csv'
require 'pp'

module Day10
  class Part2
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

      fringe = map.filter { |k,v| v == 0 }.to_a
      trails = 0

      while fringe.any?
        p, h = fringe.pop
        
        if h == 9
          trails += 1
          next
        end

        DIRS.each do |d|
          p2 = add(d,p)
          next unless map[p2] == h+1
          fringe.push([p2,h+1])
        end
      end
      
      trails
    end

    def add(a,b)
      [a[0]+b[0],a[1]+b[1]]
    end
  end
end
