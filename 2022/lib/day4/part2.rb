require 'csv'
require 'pp'

module Day4
  class Part2
    class Sector
      attr_reader :range

      def initialize(start, stop)
        @range = start..stop
      end

      def self.from_string(s)
        ends = s.split("-").map(&:to_i)
        new(*ends)
      end

      def cover?(sector)
        range.cover?(sector.range)
      end
    end

    def run(input_file)
      sector_pairs = CSV.read(input_file)
        .map { |pair| [Sector.from_string(pair[0]), Sector.from_string(pair[1])] }

      sector_pairs
        .count { |pair| overlapping_sectors?(*pair) }
    end

    def overlapping_sectors?(sector1, sector2)
      (sector1.range.to_a & sector2.range.to_a).length > 0
    end
  end
end
