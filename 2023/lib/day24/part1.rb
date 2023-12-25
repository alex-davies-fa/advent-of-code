require 'csv'
require 'pp'

module Day24
  class Part1
    X = 0; Y = 1; Z = 2;
    POINT = 0; DIR = 1;

    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      hails = lines.map do |l|
        vals = l.scan(/[\-0-9]+/).map(&:to_i)
        [vals[0..2],vals[3..-1]]
      end

      # bounds = [7,27]
      bounds = [200000000000000, 400000000000000]

      hails.combination(2).count do |l1,l2|
        i = intersection(l1,l2)[0..1]
        within?(i, bounds[0], bounds[1]) && future?(l1,i) && future?(l2,i)
      end
    end

    # Following e.g.
    # http://www.sunshine2k.de/coding/javascript/lineintersection2d/LineIntersect2D.html
    def intersection(l1,l2)
      a0, a = l1
      b0, b = l2
      u = minus(b0,a0)
      s = perpDot(b,u) * 1.0 / perpDot(b,a)
      a0.zip(a).map { |p,v| p + s * v }
    end

    def future?(line, p)
      v = minus(line[POINT][0..1],p)
      v[X] / line[DIR][X] <=  0
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

    def within?(p, lower, upper)
      p.all? { |v| v >= lower && v <= upper}
    end
  end
end
