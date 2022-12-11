require 'csv'
require 'pp'

module Day11

  # Without intervention, our worry levels get super high. However, we actually don't care about the
  # absolute worry level - just whether or not it's dividsible by a small subset of numbers (the test values for
  # each monkey). So, this class keeps track of the worry value **modulo each of the test values**.
  # When we apply an operation (adding or multipling the worry), we do the operation and immediately apply each
  # of the modulos, preventing the worry from getting out of hand.
  class Item
    attr_accessor :worry, :normalized_worries

    def initialize(worry)
      @worry = worry
    end

    def create_normalized_worries!(moduli)
      @normalized_worries = moduli.map { |m| [m, worry] }.to_h
    end

    # Applies the operation to the item for each modulo that we care about
    def update(operation)
      @normalized_worries =
        normalized_worries
          .map { |mod, worry| [mod, operation.call(worry) % mod] }
          .to_h
    end

    def test(test_val)
      normalized_worries[test_val] == 0
    end
  end

  class Monkey
    attr_reader :items, :operation, :test_val, :true_monkey, :false_monkey, :inspection_count

    def initialize(items, operation, test_val, true_monkey, false_monkey)
      @items = items
      @operation = operation
      @test_val = test_val
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

      items = items_s.split(",").map(&:to_i).map { |worry| Item.new(worry) }

      # This will break if we have anything other than 'old +* old' or 'x +* old' \o/
      operation =
        if op_val_2 == "old"
          operation = -> (val) { val.send(op, val) }
        else
          operation = -> (val) { val.send(op, op_val_2.to_i) }
        end

      new(items, operation, test_val.to_i, true_monkey.to_i, false_monkey.to_i)
    end

    def make_throws(monkeys)
      items.length.times { throw_first_item(monkeys) }
    end

    def throw_first_item(monkeys)
      item = items.shift
      item.update(operation)
      new_monkey = item.test(test_val) ? true_monkey : false_monkey

      monkeys[new_monkey].items.push(item)
      @inspection_count = @inspection_count + 1
    end
  end

  class Part2
    ROUNDS = 10000

    def run(input_file)
      monkeys = File.read(input_file).split("\n\n").map { Monkey.from_string(_1) }
      test_values = monkeys.map(&:test_val).uniq
      monkeys.flat_map(&:items).each { |item| item.create_normalized_worries!(test_values) }

      (1..ROUNDS).each do |round|
        puts "Round #{round}"
        monkeys.each_with_index do |monkey, i|
          monkey.make_throws(monkeys)
        end
      end

      puts
      pp monkeys.map(&:inspection_count).sort.last(2).inject(&:*)

      nil
    end
  end
end
