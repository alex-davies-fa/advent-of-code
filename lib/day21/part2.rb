require 'csv'
require 'pp'

module Day21
  class Part2
    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      monkeys = lines.map do |l|
        m = l[0..3].to_sym
        val = l[6..-1]
        val = val.length < 11 ? val.to_i : val.split.map(&:to_sym)
        [m, val]
      end.to_h

      monkeys[:humn] = "x"
      left = evaluate(monkeys[:root][0], monkeys)
      right = evaluate(monkeys[:root][2], monkeys)

      puts "Solve for x:"
      puts "#{left} = #{right}"

      nil
    end

    def evaluate(m, monkeys)
      case monkeys[m]
      when String
        return monkeys[m]
      when Integer
        return monkeys[m]
      when Array
        m1, op, m2 = monkeys[m]
        left = evaluate(m1, monkeys)
        right = evaluate(m2, monkeys)
        if left.class == Integer && right.class == Integer
          monkeys[m] = left.send(op, right)
        else
          monkeys[m] = "(#{left} #{op} #{right})"
        end
      end
    end
  end
end
