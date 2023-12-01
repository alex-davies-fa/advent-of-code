require 'csv'
require 'pp'

module Day21
  class Part1
    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      monkeys = lines.map do |l|
        m = l[0..3]
        val = l[6..-1]
        val = val.length < 11 ? val.to_i : val.split
        [l[0..3], val]
      end.to_h

      evaluate("root", monkeys)

      pp monkeys["root"]

      nil
    end

    def evaluate(m, monkeys)
      case monkeys[m]
      when Integer
        return monkeys[m]
      when Array
        m1, op, m2 = monkeys[m]
        monkeys[m] = evaluate(m1, monkeys).send(op, evaluate(m2, monkeys))
      end
    end
  end
end
