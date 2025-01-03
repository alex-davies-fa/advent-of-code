require 'csv'
require 'pp'

module Day5
  class Part1
    def run(input_file)
      rules_s, pages_s = File.read(input_file).split("\n\n")

      rules = Hash.new { |h, k| h[k] = [] }
      rules_a = rules_s.split("\n").map { _1.split("|").map(&:to_i) }.each { rules[_1] << _2 }
      
      pages = pages_s.split("\n").map  { _1.split(",").map(&:to_i).each_with_index.to_h }
      pages.each { _1.default = 1000 } 

      ordered_pages = pages.filter { ordered?(_1, rules) }
      ordered_pages.map { middle(_1) }.sum
    end

    def ordered?(pages, rules)
      pages.all? { |page,pos| rules[page].all? { |p2| pos < pages[p2] } }
    end

    def middle(pages)
      pages.keys[(pages.length-1)/2]
    end
  end
end
