require 'csv'
require 'pp'

module Day2
  class Part1
    def run(input_file)
      data = File.readlines(input_file).map { _1.split.map(&:to_i) } 

      data.count { |list| safe(list) } 
    end

    def sign(num)
      return 0 if num == 0
      return num < 0 ? -1 : 1
    end

    def safe(list)
      diffs = list.each_cons(2).map{ _2 - _1 }
      signs = diffs.map { sign(_1) } 

      !(diffs.any?{ _1.abs > 3} || signs.uniq.length > 1 || signs.any?(0))
    end
  end
end
