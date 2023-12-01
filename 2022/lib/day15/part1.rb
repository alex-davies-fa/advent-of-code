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

      covered_ranges = []

      sensors.each_with_index do |s, i|
        puts "Sensor #{i}/#{sensors.length}"

        y_dist = (row - s.pos[1]).abs
        next if y_dist >= s.b_dist

        spread = s.b_dist - y_dist
      covered_ranges << (s.pos[0] - spread..s.pos[0]+spread)
      end

      sensors.each { |s| covered_ranges << (s.b_pos[0]..s.b_pos[0]) if s.b_pos[1] == row }

      covered_ranges = merge_overlapping_ranges(covered_ranges)
      pp covered_ranges.map { |r| r.end - r.begin }.sum

      nil
    end

    ## Cribbed from https://stackoverflow.com/questions/6017523/
    def ranges_overlap?(a, b)
      a.include?(b.begin) || b.include?(a.begin)
    end

    def merge_ranges(a, b)
      [a.begin, b.begin].min..[a.end, b.end].max
    end

    def merge_overlapping_ranges(overlapping_ranges)
      overlapping_ranges.sort_by(&:begin).inject([]) do |ranges, range|
        if !ranges.empty? && ranges_overlap?(ranges.last, range)
          ranges[0...-1] + [merge_ranges(ranges.last, range)]
        else
          ranges + [range]
        end
      end
    end
  end
end
