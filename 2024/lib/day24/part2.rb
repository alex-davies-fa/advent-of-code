require 'csv'
require 'pp'

module Day24
  N = 45
  SWAPS = []

  class Part2
    def run(input_file)
      wires, gates, zs = read_input(input_file)

      all_gates = Set.new((0..gates.length).to_a)
      graph = Hash.new { |h,k| h[k] = [] }
      gates.each_with_index do |gate,i|
        in1,_,in2,out = gate
        graph[out] = [i,in1,in2]
      end

      # Builds lists of which gates are involved in getting to zXX
      z_gates = Hash.new { |h,k| h[k] = Set.new }
      zs.each do |z|
        fringe = [z]
        while el = fringe.pop
          gate_i, in1, in2 = graph[el]
          z_gates[z].add(gate_i)
          [in1,in2].each { fringe << _1 unless _1.start_with?("x") || _1.start_with?("y") }
        end
      end

      d = 0
      while SWAPS.length < 8
        good_gates = Set.new
        maybe_bad_gates = Set.new

        (d..N).each do |i|
          correct = circuit_correct?(gates,i)
          if correct
            good_gates.merge(z_gates[to_w('z',i)])
          else
            maybe_bad_gates = Set.new(z_gates[to_w('z',i)]) - good_gates
            d = i
            break
          end
        end

        possible_swaps = (all_gates).to_a.product(maybe_bad_gates.to_a)

        possible_swaps.each do |a,b|
          new_gates = gates.map{ _1.dup } 
          swap(new_gates,a,b)
          if circuit_correct?(new_gates,d)
            swap(gates,a,b,true)
            pp SWAPS
            break
          end
        end
      end

      puts
      SWAPS.sort.join(",")
    end

    def swap(gates,a,b,store=false)
      out_a = gates[a][3]
      out_b = gates[b][3]
      SWAPS.push(out_a,out_b) if store
      gates[a][3] = out_b
      gates[b][3] = out_a
    end

    def to_w(c,i)
      c + "%02d" % i
    end

    def circuit_correct?(gates, compare)
      (0..100).all? { test_random(gates, compare) }
    end

    def test_random(gates, compare)
      wires = {}
      xs = []
      ys = []
      (0...N).each do |i|
        xs << "x" + "%02d" % i
        ys << "y" + "%02d" % i
      end
      (xs + ys).each { wires[_1] = [0,1].sample }

      xs_b = xs.reverse.map { wires[_1] }.join
      ys_b = ys.reverse.map { wires[_1] }.join
      correct_d = xs_b.to_i(2) + ys_b.to_i(2)
      correct_b = correct_d.to_s(2).rjust(N+1,' ')
      
      out = run_circuit(wires, gates)

      correct_b.chars.last(compare) == out.chars.last(compare)   
    end

    def run_circuit(wires,gates)
      zs = (0..N).map { |i| "z" + "%02d" % i }
      stalled = false
      while zs.any? { wires[_1].nil? && !stalled }
        stalled = true
        gates.each do |in1,op,in2,out|
          next unless wires.key?(in1) && wires.key?(in2) && !wires.key?(out)
          wires[out] = apply(op,wires[in1],wires[in2])
          stalled = false
        end
      end

      zs.reverse.map { wires[_1] }.join.to_s
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
