require 'csv'
require 'pp'

module Day13
  class Part2
    def run(input_file)
      packets = File.read(input_file).squeeze("\n").split("\n").map { |string| parse(string) }
      packets += [[[2]],[[6]]]

      sorted = packets.sort { |p1, p2| compare(p1.clone, p2.clone) }.reverse
      div1 = sorted.find_index { _1 == [[2]] } + 1
      div2 = sorted.find_index { _1 == [[6]] } + 1
      pp div1 * div2

      nil
    end

    def compare(p1,p2)
      left = p1.shift
      right = p2.shift

      case [left, right]
      in [nil, nil]
        return 0
      in [nil, _]
        return 1
      in [_, nil]
        return -1
      in [Integer, Integer]
        return 1 if left < right
        return -1 if left > right
        return compare(p1.clone,p2.clone)
      in [Integer, Array]
        p1.unshift([left])
        p2.unshift(right)
        compare(p1.clone,p2.clone)
      in [Array, Integer]
        p1.unshift(left)
        p2.unshift([right])
        compare(p1.clone,p2.clone)
      in [Array, Array]
        list_compare = compare(left.clone, right.clone)
        return compare(p1.clone,p2.clone) if list_compare == 0
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
