require 'csv'
require 'pp'
require 'z3'

module Day10
  class Part3
    def run(input_file)
      lines = File.readlines(input_file).map { |l| l.chomp.split(" ") }
      machines = lines.map do |l|
        buttons = l[1..-2].map { _1[1..-2].split(",").map(&:to_i) }
        buttons = buttons.sort_by { _1.length }
        joltages = l[-1][1..-2].split(",").map(&:to_i)
        
        { buttons: , joltages: }
      end

      machines.sum do |machine|
        minimize(machine)
      end
    end

    def minimize(machine)
      solver = Z3::Optimize.new
      vars = []

      machine[:buttons].each_index do |b|
        vars[b] = Z3.Int(as_var(b))
        solver.assert(vars[b] >= 0)
      end

      machine[:joltages].each_with_index do |jolt, j|
        relevant_buttons = []
        machine[:buttons].each_with_index do |button,i|
          relevant_buttons << vars[i] if button.include?(j)
        end
        solver.assert(relevant_buttons.sum == jolt)
      end

      solver.minimize(vars.sum)
      solver.satisfiable?

      vars.sum { |v| solver.model[v].to_i }
    end

    def as_var(i)
      (97+i).chr
    end
  end
end
