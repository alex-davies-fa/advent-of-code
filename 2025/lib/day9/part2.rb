require 'csv'
require 'pp'

module Day9
  X = 0; Y = 1;

  class Part2
    def run(input_file)
      ps = File.readlines(input_file).map { |l| l.split(",").map(&:to_i) }
      lines = ps.each_cons(2).map { |p1,p2| [p1,p2] }
      lines << [ps.last,ps.first]

      max = 0
      ps.combination(2).each do |p1,p2|
        val = size(p1, p2)
        next unless val > max

        corners = [p1,[p1[0],p2[1]],p2,[p2[0],p1[1]]]
        edges = (corners + [corners[0]]).each_cons(2)
        
        good = true
        lines.each do |l|
          if edges.any? { |e| i = intersection(e, l); i && !corners.include?(i) }
            good = false
            break
          end
        end
        next if !good

        pp max
        max = val 
      end

      max
    end

    def size(p1,p2)
      ((p1[0]-p2[0]).abs + 1) * ((p1[1]-p2[1]).abs + 1)
    end

    def intersection(l1,l2)
      a0, a = [l1[0], minus(l1[1],l1[0])]
      b0, b = [l2[0], minus(l2[1],l2[0])]
      u = minus(b0,a0)
      v = minus(a0,b0)
      s = perpDot(b,u) * 1.0 / perpDot(b,a)
      t = perpDot(a,v) * 1.0 / perpDot(a,b)
      if (0..1).include?(s) && (0..1).include?(t)
        a0.zip(a).map { |p,v| (p + s * v).to_i }
      else
        nil
      end
    end

    def perpDot(a,b)
      a[X] * b[Y] - a[Y] * b[X]
    end

    def add(a,b)
      a.zip(b).map { _1 + _2 }
    end

    def minus(a,b)
      a.zip(b).map { _1 - _2 }
    end
  end
end
