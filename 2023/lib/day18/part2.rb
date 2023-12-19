require 'csv'
require 'pp'

module Day18
  class Part2
    DIRS = {
      "3" => [-1,0],
      "1" => [1,0],
      "0" => [0,1],
      "2" => [0,-1]
    }

    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      instructions = lines.map do |l|
        hex = l.split(" ")[-1][2..-2]
        dist = hex[0..-2]
        dir = hex[-1]
        [DIRS[dir], dist.to_i(16)]
      end

      verts = [[0,0]]
      edge_length = 0

      instructions.each do |dir, dist|
        verts << add(verts.last,times(dir,dist))
        edge_length += dist
      end

      # See https://web.archive.org/web/20100405070507/http://valis.cs.uiuc.edu/~sariel/research/CG/compgeom/msg00831.html

      verts = verts[0..-2] # Don't want repeated last node
      n = verts.length
      area = 0
      (0...n).each do |i|
        j = (i+1) % n
        area += verts[i][1] * verts[j][0]
        area -= verts[i][0] * verts[j][1]
      end

      (area / 2) + (edge_length / 2) + 1
    end

    def add(a,b)
      [a[0]+b[0],a[1]+b[1]]
    end

    def times(v,k)
      v.map { _1 * k }
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

