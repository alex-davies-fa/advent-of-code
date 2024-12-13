require 'csv'
require 'pp'

module Day13
  class Part1
    def run(input_file)
      machines = File.read(input_file).split("\n\n").map { _1.split("\n") }
      
      total = 0
      machines.each do |m|
        ax,ay = m[0].scan(/\d+/).map(&:to_f)
        bx,by = m[1].scan(/\d+/).map(&:to_f)
        x,y = m[2].scan(/\d+/).map(&:to_f)

        b = ((y - ay*x/ax)/(by - bx*ay/ax)).round
        a = ((x - b*bx)/ax).round

        if a*ax+b*bx == x.round && a*ay+b*by == y.round
          total += 3*a + b
        end
      end

      total
    end
  end
end
