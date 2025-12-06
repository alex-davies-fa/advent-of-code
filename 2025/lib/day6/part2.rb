require 'csv'
require 'pp'

module Day6
  class Part2
    def run(input_file)
      lines = File.readlines(input_file)

      cols = lines[..-2].map(&:chars).transpose
      divs = cols.each_with_index.select { |c,i| c.all?(" ") }.map { _1[1] }

      nums = lines[..-2]
        .map { |l| divs.each { |d| l[d] = "-" }; l }
        .map { |l| l[0..-2].split("-") }
        .transpose

      v_nums = nums.map do |ns|
        ns.map(&:chars).transpose.map { _1.join.strip.to_i }
      end

      ops = lines[-1].split

      (0...ops.length).sum do |i|
        if ops[i] == "+"
          v_nums[i].sum
        else
          v_nums[i].inject(&:*)
        end
      end
    end
  end
end
