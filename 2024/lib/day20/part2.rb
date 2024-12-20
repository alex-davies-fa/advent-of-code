require 'csv'
require 'pp'

module Day20
  class Part2
    DIRS = [
      [1,0],
      [0,1],
      [-1,0],
      [0,-1],
    ]

    def run(input_file)
      map, s, e = read_input(input_file)

      path = get_path(map, s, e)
      cuts = get_cuts(path,map)

      total_dist = path.length
      path_inds = path.each_with_index.to_h

      savings = cuts.map do |c|
        s_ind, e_ind = [path_inds[c[0]],path_inds[c[1]]].sort
        (e_ind - s_ind) - dist(c[0],c[1])
      end

      savings.count { _1 >= 100 }
    end

    def get_cuts(path,map)
      path.combination(2).filter { cuttable?(_1,_2,map) }
    end

    def get_path(map, s, e)
      path = [s]
      map.delete(s)
      while p2 = adj(path.last, map).first
        path << p2
        map.delete(p2)
      end
      path
    end

    def adj(p, map)
      DIRS.map { |d| p2 = add(p,d); p2 if map.include?(p2) }.compact
    end

    def cuttable?(a,b,map)
      x_dist = (a[0] - b[0]).abs
      y_dist = (a[1] - b[1]).abs
      dist(a,b) <= 20
    end

    def dist(a,b)
      (a[0]-b[0]).abs + (a[1]-b[1]).abs
    end

    def add(a,b)
      [a[0]+b[0],a[1]+b[1]]
    end

    def read_input(input_file)
      lines = File.readlines(input_file)
      map = Set.new
      s = nil
      e = nil

      lines.each_with_index do |l,y|
        lines[y].strip.chars.each_with_index do |c,x|
          map.add([x,y]) if c != '#'
          s = [x,y] if c == 'S'
          e = [x,y] if c == 'E'
        end
      end

      [map,s,e]
    end
  end
end
