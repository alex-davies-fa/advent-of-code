require 'csv'
require 'pp'

module Day11
  class Monkey
    attr_reader :items, :operation, :test_op, :true_monkey, :false_monkey, :inspection_count

    def initialize(items, operation, test_op, true_monkey, false_monkey)
      @items = items
      @operation = operation
      @test_op = test_op
      @true_monkey = true_monkey
      @false_monkey = false_monkey
      @inspection_count = 0
    end

    def self.from_string(string)
      lines = string.lines.each
      lines.next
      /Starting items: (?<items_s>.*)/ =~ lines.next
      /Operation: new = (?<op_val_1>\w+) (?<op>.) (?<op_val_2>\w+)/ =~ lines.next
      /Test: divisible by (?<test_val>\d+)/ =~ lines.next
      /If true: throw to monkey (?<true_monkey>\d+)/ =~ lines.next
      /If false: throw to monkey (?<false_monkey>\d+)/ =~ lines.next

      items = items_s.split(",").map(&:to_i)

      # This will break if we have anything other than 'old +* old' or 'x +* old' \o/
      operation =
        if op_val_2 == "old"
          operation = -> (val) { val.send(op, val) }
        else
          operation = -> (val) { val.send(op, op_val_2.to_i) }
        end

      test_op = -> (val) { val % test_val.to_i == 0 }

      new(items, operation, test_op, true_monkey.to_i, false_monkey.to_i)
    end

    def make_throws(monkeys)
      items.length.times { throw_first_item(monkeys) }
    end

    def throw_first_item(monkeys)
      item = items.shift
      item = operation.call(item)
      item = item / 3
      new_monkey = test_op.call(item) ? true_monkey : false_monkey

      monkeys[new_monkey].items.push(item)
      @inspection_count = @inspection_count + 1
    end
  end

  class Part1
    ROUNDS = 20

    def run(input_file)
      monkeys = File.read(input_file).split("\n\n").map { Monkey.from_string(_1) }

      (1..ROUNDS).each do |round|
        puts "Round #{round}"
        monkeys.each_with_index do |monkey, i|
          puts "Monkey #{i}"
          monkey.make_throws(monkeys)
        end
        puts
      end

      pp monkeys.map(&:items)
      pp monkeys.map(&:inspection_count).sort.last(2).inject(&:*)

      nil
    end
  end
end
