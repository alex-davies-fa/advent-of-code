require 'csv'
require 'pp'

module Day3
  class Rucksack
    attr_reader :first, :second

    def initialize(first, second)
      @first = first.chars
      @second = second.chars
    end

    def self.from_string(string)
      size = string.length / 2
      new(string[0..size-1], string[size..-1])
    end

    def bad_item
      (first & second).first
    end
  end

  class Part1
    def run(input_file)
      rucksacks = File.readlines(input_file).map { |s| Rucksack.from_string(s) }
      pp rucksacks.map { |rucksack| item_value(rucksack.bad_item) }.sum
      nil
    end

    def item_value(item)
      lowercase = item != item.upcase
      return item.ord - 'a'.ord + 1 if lowercase

      item.ord - 'A'.ord + 27
    end
  end
end
