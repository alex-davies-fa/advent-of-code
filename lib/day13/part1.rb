require 'csv'
require 'pp'

module Day13
  class Part1
    def run(input_file)
      pairs = File.read(input_file).split("\n\n")
      pairs = pairs.map { |pair| pair.split("\n").map { |string| parse(string) } }

      pp pairs
      pp pairs.
        each_index.select { |i| compare(pairs[i][0], pairs[i][1]) }.map { _1 + 1 }.sum

      nil
    end

    def compare(p1,p2)
      left = p1.shift
      right = p2.shift

      # We've run out of items on at least one list
      if left.nil? && right.nil?
        return nil
      elsif left.nil? && !right.nil?
        return true
      elsif !left.nil? && right.nil?
        return false
      end

      # Comparison
      if int?(left) && int?(right)
        return true if left < right
        return false if left > right
        return compare(p1,p2)
      elsif int?(left) && !int?(right)
        p1.unshift([left])
        p2.unshift(right)
        compare(p1,p2)
      elsif !int?(left) && int?(right)
        p1.unshift(left)
        p2.unshift([right])
        compare(p1,p2)
      else
        list_compare = compare(left, right)
        return compare(p1,p2) if list_compare.nil?
        return list_compare
      end
    end

    def int?(o)
      o.is_a?(Integer)
    end

    def parse(string)
      stack = [[]]
      itr = string.chars[1..-1].each
      loop do
        c = itr.next
        curr_array = stack.last
        if c =~ /[0-9]/
          c += itr.next while itr.peek =~ /[0-9]/
          curr_array << c.to_i
        elsif c == '['
          new_arr = []
          curr_array.push(new_arr)
          stack.push(new_arr)
        elsif c == ']'
          stack.pop unless stack.length == 1
        else
          # Comma
        end
      end
      stack.first
    end
  end
end
