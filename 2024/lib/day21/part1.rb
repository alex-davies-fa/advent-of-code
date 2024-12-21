require 'csv'
require 'pp'

module Day21
  class Part1
    DIRS = {
      '^' => [1,0],
      '<' => [0,1],
      'v' => [1,1],
      '>' => [2,1],
      'A' => [2,0],
    }

    DIRS_C = {
      [0,-1] => '^',
      [-1,0] => '<',
      [0,1] => 'v',
      [1,0] => '>',
    }

    NUMS = {
      '7' => [0,0],
      '8' => [1,0],
      '9' => [2,0],
      '4' => [0,1],
      '5' => [1,1],
      '6' => [2,1],
      '1' => [0,2],
      '2' => [1,2],
      '3' => [2,2],
      '0' => [1,3],
      'A' => [2,3],
    }

    def run(input_file)
      codes = File.readlines(input_file).map { _1.strip.chars }


      codes.sum do |code|
        num = code[0..-2].join.to_i
        dirs1 = shortest_inputs(code,NUMS)
        dirs2 = dirs1.flat_map { |d| shortest_inputs(d.chars,DIRS) }
        dirs3 = dirs2.flat_map { |d| shortest_inputs(d.chars,DIRS) }
        min_length =  dirs3.map(&:length).min
        min_length * num
      end
    end

    def shortest_inputs(sequence, keypad)
      pos = keypad['A']
      moves = [""]
      sequence.each do |v|
        step_options = steps_from(pos, keypad[v],keypad)
        moves = moves.product(step_options).map { |m,s| m + s.join + "A" }
        pos = keypad[v]
      end
      moves
    end

    def dist(a,b)
      (a[0]-b[0]).abs + (a[1]-b[1]).abs
    end

    def steps_from(a,b,keypad)
      d = diff(a,b)

      # xsteps or ysteps first
      x_steps = d[0] == 0 ? [] : ([[d[0]/d[0].abs,0]]*d[0].abs)
      y_steps = d[1] == 0 ? [] : ([[0,d[1]/d[1].abs]]*d[1].abs)
      step_options = [x_steps + y_steps, y_steps + x_steps].uniq

      # Check for going through illegal space
      step_options = step_options.reject do |steps|
        p = a
        bad = false
        steps.each do |s|
          p = add(p,s)
          bad = true if !keypad.invert.key?(p)
        end
        
        bad
      end
      
      step_options.map { |steps| steps.map { DIRS_C[_1] } }
    end

    def add(a,b)
      [a[0]+b[0],a[1]+b[1]]
    end

    def diff(a,b)
      [(b[0]-a[0]), (b[1]-a[1])]
    end
  end
end
