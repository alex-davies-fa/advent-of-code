require 'csv'
require 'pp'

module Day15
  class Part1
    class Sensor
      attr_reader :pos, :b_pos

      def initialize(x,y,bx,by)
        @pos = Vector[x,y]
        @b_pos = Vector[bx,by]
      end

      def b_dist
        manhat(pos, b_pos)
      end

      def dist_to(pos2)
        manhat(pos, pos2)
      end

      def manhat(a,b)
        (a - b).map(&:abs).sum
      end
    end

    def run(input_file)
      lines = File.readlines(input_file)
      sensors = lines.map do |line|
        /Sensor at x=(?<x>\-?\d+), y=(?<y>\-?\d+): closest beacon is at x=(?<bx>\-?\d+), y=(?<by>\-?\d+)/ =~line
        Sensor.new(x.to_i,y.to_i,bx.to_i,by.to_i)
      end

      bounds = sensors.length < 20 ? 20 : 4000000
      row = sensors.length < 20 ? 10 : 2000000 # lol
      excluded = Set.new

      sensors.each_with_index do |s, i|
        puts "Sensor #{i}/#{sensors.length}"

        closest_pos = Vector[s.pos[0],row]
        step = 0
        step_v = Vector[1,0]

        next if s.dist_to(closest_pos) >= s.b_dist

        spread = s.b_dist - s.dist_to(closest_pos)
        to_add = (s.pos[0] - spread..s.pos[0]+spread).map { |x| Vector[x,row] }
        excluded.merge(to_add)
      end

      sensors.each { |s| excluded.delete(s.b_pos) }

      # pp excluded.sort_by { |v| v[0] }
      pp excluded.length
      # pp excluded
      # pp excluded.count { |s| s[0] >= 0 && s[0] <= bounds }
      nil
    end
  end
end
