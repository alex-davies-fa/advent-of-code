require 'csv'
require 'pp'

module Day2
  class Part2
    def run(input_file)
      data = File.readlines(input_file).map { _1.split.map(&:to_i) } 

      data.count{ |list| variants(list).any?{safe(_1)}} 
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

    def variants(list)
      vars = (0..list.length-1).map do |i|
        list.dup.tap { _1.delete_at(i) } 
      end
      vars << list
    end
  end
end
