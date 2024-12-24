require 'csv'
require 'pp'

module Day24
  class Part1
    def run(input_file)
      wires, gates, zs = read_input(input_file)

      cycles = 1
      while zs.any? { wires[_1].nil? }
        pp cycles
        cycles += 1
        gates.each do |in1,op,in2, out|
          next unless wires.key?(in1) && wires.key?(in2)
          wires[out] = apply(op,wires[in1],wires[in2])
        end
      end

      zs.reverse.map { wires[_1] }.join.to_s.to_i(2)
    end

    def apply(op,in1,in2)
      if op == "AND"
        in1 == 1 && in2 == 1 ? 1 : 0
      elsif op == "XOR"
        (in1 + in2 == 1) ? 1 : 0 
      elsif op == "OR"
        in1 == 1 || in2 == 1 ? 1 : 0 
      end
    end

    def read_input(input_file)
      initial_s, gates_s = File.read(input_file).split("\n\n")
      wires = {}
      initial_s.split("\n").each do |l|
        name, val = l.strip.split(": ")
        wires[name] = val.to_i
      end

      gates = []
      zs = []
      gates_s.split("\n").each do |l|
        in1, op, in2, _, out = l.split(" ")
        gates << [in1,op,in2,out]
        zs << out if out.start_with?('z')
      end

      [wires, gates, zs.sort]
    end
  end
end
