require 'csv'
require 'pp'

module Day12
  class Part2
    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      rows = lines.map do |row|
        record, groups = row.split
        groups = groups.split(",").map(&:to_i)
        {
          record: ((record.split("") + ["?"]) * 5)[0..-2].join(""),
          groups: groups * 5
        }
      end

      memos = {}
      rows.each_with_index.sum do |row, i|
        permutations(row[:record], row[:groups], memos)
      end
    end

    def permutations(record, groups, memos = {})
      if groups.length == 0
        if record.include?("#")
          return 0
        else
          return 1
        end
      end

      if record.nil? || record.length == 0
        return 0
      end

      if record.count("#?") < groups.sum || record.count("#") > groups.sum
        return 0
      end

      memo = memos[[record, groups]]
      return memo if memo

      group = groups.first
      positions = valid_positions(group, record)

      right_groups = groups[1..-1]

      positions.sum do |p|
        left_record = p-1 < 0 ? "" : record[0...(p-1)]
        right_record = p+group+1 >= record.length ? "" : record[(p+group+1)..-1]

        left_perms = permutations(left_record, [], memos)
        right_perms = permutations(right_record, right_groups, memos)
        memos[[right_record, right_groups]] = right_perms

        left_perms * right_perms
      end
    end

    def valid_positions(group_length, record)
      (0..(record.length-group_length)).map do |i|
        if !record[i...i+group_length].include?(".") &&
          record[i+group_length] != "#" &&
          (i == 0 || record[i-1] != "#" )
          i
        end
      end.compact
    end
  end
end
