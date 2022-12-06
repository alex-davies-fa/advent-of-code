require 'csv'
require 'pp'

module Day4
  class Part1
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

      sector_pairs.count { |pair| pair_overlap?(*pair) }
    end

    def pair_overlap?(sector1, sector2)
      sector1.cover?(sector2) || sector2.cover?(sector1)
    end
  end
end
