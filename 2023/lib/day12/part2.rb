require 'csv'
require 'pp'

module Day12
  class Part2
    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      rows = lines.map do |row|
        record, groups = row.split
        record = record.split("")
        groups = groups.split(",").map(&:to_i)
        {
          record: ((record + ["?"]) * 5)[0..-2],
          groups: groups * 5
          # record:,
          # groups:
        }
      end

      complete = 0
      counts = rows.map do |row|
        puts complete
        complete += 1
        # pp valid_perms(row[:record],row[:groups]).map(&:join)
        valid_perms(row[:record],row[:groups]).length
      end

      pp counts.sum
      nil
    end

    def valid_perms(record, groups, d = "")
      # puts d + record.join("")
      if groups.sum > record.count { _1 == "?" || _1 == "#" }
        return []
      end
      if record.count { _1 == "#" } > groups.sum
        return []
      end
      if invalid?(record, groups)
        return []
      end


      first_unknown = record.find_index { _1 == "?" }

      return [record] if !first_unknown

      # Branch 1 - fill with "."
      record1 = record.dup
      record1[first_unknown] = "."
      branch1 = valid_perms(record1, groups, d + "-")

      # Branch 2 - fill whole next group if possible
      branch2 = []
      record2 = record.dup
      group_start = first_unknown
      while group_start-1 >= 0 && record2[group_start-1] == "#"
        group_start -= 1
      end
      group_length = next_needed_group(record2, groups)
      if group_length && record2.length >= group_start + group_length
        vals_to_fill = record2[group_start...group_start+group_length] # These must all be ? or #
        if vals_to_fill.none? { _1 == "." } && vals_to_fill.any? { _1 == "?" }
          record2.fill("#", group_start, group_length)

          if record2[group_start+group_length] == '#' # This is illegal
            branch2 = []
          else
            record2[group_start+group_length] = "." # Have to have a "." next
            branch2 = valid_perms(record2, groups, d + "-")
          end
        end
      end

      branch1 + branch2
    end

    def next_needed_group(record, groups)
      complete_chunk = record[0...record.index("?")]
      return groups.first unless complete_chunk.rindex(".")
      decided_record = complete_chunk[0..complete_chunk.rindex(".")]
      decided_groups = get_groups(decided_record)
      groups[decided_groups.length]
    end

    def valid?(record, groups)
      groups == get_groups(record)
    end

    def get_groups(record)
      record.join.scan(/#+/).map(&:length)
    end

    def invalid?(record, groups)
      complete_chunk = record[0...record.index("?")]
      return false unless complete_chunk.rindex(".")
      decided_record = complete_chunk[0..complete_chunk.rindex(".")]
      decided_groups = get_groups(decided_record)

      return false unless decided_groups.any?

      decided_groups != groups[0...decided_groups.length]
    end
  end
end
