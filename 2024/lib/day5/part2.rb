require 'csv'
require 'pp'

module Day5
  class Part2
    def run(input_file)
      rules_s, pages_s = File.read(input_file).split("\n\n")

      rules = Hash.new { |h, k| h[k] = [] }
      rules_a = rules_s.split("\n").map { _1.split("|").map(&:to_i) }.each { rules[_1] << _2 }
      
      pages = pages_s.split("\n").map  { _1.split(",").map(&:to_i).each_with_index.to_h }
      pages.each { _1.default = 1000 } 
      
      unordered_pages = pages.filter { !ordered?(_1, rules) }

      unordered_pages.map { |p| middle(sort(relevant_rules(p, rules))) }.sum
    end

    def sort(rules)
      rules.sort_by { |page, before| before.length }.map(&:first).reverse
    end

    def relevant_rules(pages, all_rules)
      rules = {}
      pages.each do |p, _|
        rules[p] = all_rules[p].filter { pages.keys.include?(_1) }
      end

      rules
    end

    def ordered?(pages, rules)
      pages.all? { |page,pos| rules[page].all? { |p2| pos < pages[p2] } }
    end

    def middle(pages)
      pages[(pages.length-1)/2]
    end
  end
end
