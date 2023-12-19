require 'csv'
require 'pp'

module Day18
  class Part1
    DIRS = {
      "U" => [-1,0],
      "D" => [1,0],
      "R" => [0,1],
      "L" => [0,-1]
    }

    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      instructions = lines.map do |l|
        dir, dist = l.split(" ")[0..1]
        [DIRS[dir], dist.to_i]
      end

      edges = Set.new()
      pos = [0,0]
      edges.add(pos)

      instructions.each do |dir, dist|
        dist.times do
          pos = add(pos,dir)
          edges.add(pos)
        end
      end

      ymin, ymax = edges.map {_1[0]} .minmax
      xmin, xmax = edges.map {_1[1]}.minmax
      start = [(ymin+ymax)/2, (xmin+xmax)/2] # Could be wrong, but fine for these examples

      points = Set.new
      fringe = [start]
      points.add(start)

      while(p = fringe.pop)
        DIRS.values.each do |d|
          new_p = add(p,d)
          if !edges.include?(new_p) && !points.include?(new_p)
            points.add(new_p)
            fringe << new_p
          end
        end
      end

      edges.length + points.length
    end

    def add(a,b)
      [a[0]+b[0],a[1]+b[1]]
    end

    def display(edges, points = Set.new)
      ymin, ymax = edges.map {_1[0]} .minmax
      xmin, xmax = edges.map {_1[1]}.minmax
      (ymin..ymax).each do |y|
        out = ""
        (xmin..xmax).each do |x|
          out <<
            if edges.include?([y,x])
              "#"
            elsif points.include?([y,x])
              "."
            else
              " "
            end
        end
        puts out
      end
    end
  end
end
