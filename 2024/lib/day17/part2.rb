require 'csv'
require 'pp'

module Day17
  class Part2
    # attr_accessor :a, :b, :c

    def run(input_file)
      rs,ps = File.read(input_file).split("\n\n")
      initial_regs = rs.scan(/\d+/).map(&:to_i)
      program = ps.scan(/\d+/).map(&:to_i)

      digits = [0]*16
      di = 0
      out = nil
      
      while out != program
        matched = false
        while digits[di] < 8
          a_val = digits.map(&:to_s).join().to_i(8)

          @a, @b, @c = initial_regs
          @a = a_val

          out = execute(program) 

          if out.length == program.length && out[-1-di] == program[-1-di]
            matched = true
            break
          else
            digits[di] = digits[di] + 1
          end
        end
        if matched
          di += 1
        else
          digits[di] = 0
          di -= 1
          digits[di] = digits[di] + 1
        end
      end

      digits.map(&:to_s).join().to_i(8)
    end



    def execute(program)
      i = 0
      out = []

      while i < program.length do
        ins, op = program[i..i+1]
        no_jump = false

        case ins
        when 0
          # The adv instruction (opcode 0) performs division. The numerator is the value in the A register. The denominator is found by raising 2 to the power of the instruction's combo operand. (So, an operand of 2 would divide A by 4 (2^2); an operand of 5 would divide A by 2^B.) The result of the division operation is truncated to an integer and then written to the A register.
          res = (@a*1.0/(2**combo(op))).truncate
          @a = res
        when 1
          # The bxl instruction (opcode 1) calculates the bitwise XOR of register B and the instruction's literal operand, then stores the result in register B.
          res = @b ^ op
          @b = res
        when 2
          # The bst instruction (opcode 2) calculates the value of its combo operand modulo 8 (thereby keeping only its lowest 3 bits), then writes that value to the B register.
          res = combo(op) % 8
          @b = res
        when 3
          # The jnz instruction (opcode 3) does nothing if the A register is 0. However, if the A register is not zero, it jumps by setting the instruction pointer to the value of its literal operand; if this instruction jumps, the instruction pointer is not increased by 2 after this instruction.
          if @a > 0
            i = op
            no_jump = true
          end
        when 4
          # The bxc instruction (opcode 4) calculates the bitwise XOR of register B and register C, then stores the result in register B. (For legacy reasons, this instruction reads an operand but ignores it.)
          res = @b ^ @c
          @b = res
        when 5
          # The out instruction (opcode 5) calculates the value of its combo operand modulo 8, then outputs that value. (If a program outputs multiple values, they are separated by commas.)
          out << combo(op) % 8
        when 6
          # The bdv instruction (opcode 6) works exactly like the adv instruction except that the result is stored in the B register. (The numerator is still read from the A register.)
          res = (@a*1.0/(2**combo(op))).truncate
          @b = res
        when 7
          # The cdv instruction (opcode 7) works exactly like the adv instruction except that the result is stored in the C register. (The numerator is still read from the A register.)
          res = (@a*1.0/(2**combo(op))).truncate
          @c = res
        end

        i += 2 unless no_jump
      end

      out
    end

    def combo(v)
      return v if v <= 3
      return @a if v == 4
      return @b if v == 5
      return @c if v == 6
      raise "Illegal combo operand"
    end
  end
end
