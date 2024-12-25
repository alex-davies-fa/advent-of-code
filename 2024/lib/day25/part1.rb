require 'csv'
require 'pp'

module Day25
  class Part1
    def run(input_file)
      items_s = File.read(input_file).split("\n\n")
      items = items_s.map { |item| item.lines.map { _1.strip.chars } }

      locks = items.filter { _1[0][0] == '#' }
      keys = items.filter { _1[0][0] == '.' }
      lock_heights = locks.map { col_heights(_1) }
      key_heights = keys.map { col_heights(_1) }

      pairs = lock_heights.product(key_heights)
      
      pairs.count { could_fit?(_1,_2) }
    end

    def could_fit?(lock,key)
      lock.zip(key).all? { _1 + _2 <= 5 }
    end

    def col_heights(item)
      item.transpose.map { |col| col.count { _1 == "#" } - 1}
    end
  end
end
