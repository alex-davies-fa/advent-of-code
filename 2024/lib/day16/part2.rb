require 'csv'
require 'pp'

module Day16
  class Part2
    DIRS = [
      [0,-1],
      [0,1],
      [1,0],
      [-1,0],
    ]

    def run(input_file)
      map, s, e = read_input(input_file)
      dummy_start = add(s,[-1,0])
      segs = get_segs(map.dup, dummy_start, [1,0])
      segs.delete(dummy_start)

      # [path, visited, cost]
      fringe = [[[dummy_start,s], Set.new, 0]]
      full_paths = []
      min_score = nil

      # [pos, dir] => cost
      best_cost = {}

      while fringe.any?
        path,visited,cost = fringe.pop

        next_nodes = segs[path.last].reject { |n| visited.include?(n) }
        next_nodes.each do |n|
          new_path = path.dup << n
          new_cost = cost + dist(*new_path.last(2))
          new_cost += 1000 if !same_dir(new_path.last(3))
          
          next if min_score && h_cost(new_path,new_cost,e) > min_score

          d = dir(*new_path.last(2))

          if n == e
            full_paths << [new_path, new_cost]
            old_min_score = min_score
            min_score = [min_score, new_cost].compact.min
            pp min_score if !old_min_score || min_score < old_min_score
          else
            if best_cost[[n,d]].nil? || best_cost[[n,d]] >= new_cost
              best_cost[[n,d]] = new_cost
              fringe << [new_path, Set.new(new_path), new_cost]
            end
          end
        end
      end

      best_paths = full_paths.select { _1.last == min_score }.map(&:first)
      best_segs = Set.new
      best_paths.map { |path| path.each_cons(2).each { best_segs.add(_1.sort) } }
      best_points = best_segs.flat_map { all_points(_1) }.uniq
      best_points.length - 1
    end

    def all_points(seg)
      p1, p2 = seg
      out = []
      (p1[0]..p2[0]).each do |x|
        (p1[1]..p2[1]).each do |y|
          out << [x,y]
        end
      end
      out
    end

    def h_cost(path,cost,e)
      cost + dist(path.last,e)
    end

    def dir(a,b)
      [(b[0]-a[0])/dist(a,b),(b[1]-a[1])/dist(a,b)]
    end

    def dist(p1,p2)
      (p1[0]-p2[0]).abs + (p1[1]-p2[1]).abs
    end

    def same_dir(ps)
      (ps[0][0] == ps[1][0] && ps[1][0] == ps[2][0]) || (ps[0][1] == ps[1][1] && ps[1][1] == ps[2][1])
    end

    # build a list of
    # {start => [end1, end2] }
    def get_segs(map, p, d, segs = Hash.new { |h,k| h[k] = [] } )
      # Walk until we find an intersection
      e = add(p,d)
      map.delete(e)
      while adj(e,map).length == 1 && map.include?(add(e,d))
        e = add(e,d)
        map.delete(e)
      end

      segs[p] << e
      segs[e] << p

      next_dirs = adj(e,map).map { _1[1] }
      
      next_dirs.each { |d| get_segs(map, e, d, segs) }

      segs
    end

    def adj(p, map)
      DIRS.map { |d| p2 = add(p,d); [p2,d] if map.include?(p2) }.compact
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
