require 'csv'
require 'pp'

module Day12
  class Part1
    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      rows = lines.map do |row|
        record, groups = row.split
        record = record.split("")
        groups = groups.split(",").map(&:to_i)
        { record:, groups: }
      end

      counts = rows.map do |row|
        all_perms(row[:record]).count { |perm| valid?(perm, row[:groups]) }
      end

      counts.sum
    end

    def all_perms(record)
      first_unknown = record.find_index { _1 == "?" }
      return [record] unless first_unknown

      perm1 = record.dup
      perm1[first_unknown] = "."
      perm2 = record.dup
      perm2[first_unknown] = "#"
      all_perms(perm1) + all_perms(perm2)
    end

    def valid?(record, groups)
      counts = record.join.scan(/#+/).map(&:length)
      groups == counts
    end
  end
end
