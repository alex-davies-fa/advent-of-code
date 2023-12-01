require 'csv'
require 'pp'
require "ostruct"


module Day5
  class Part1
    def run(input_file)
      stack_string, move_string = File.read(input_file).split("\n\n")

      stacks = read_stacks(stack_string)
      moves = read_moves(move_string)

      moves.each do |move|
        move.num.times do
          item = stacks[move.from-1].pop
          stacks[move.to-1].push(item)
        end
      end

      pp stacks

      stacks.map(&:pop).join
    end

    def read_moves(move_string)
      moves = move_string.split("\n")
        .map { |line| read_move(line) }
    end

    def read_move(string)
      num, from, to = string.match("move ([0-9]+) from ([0-9]+) to ([0-9]+)").captures
      OpenStruct.new(num: num.to_i, from: from.to_i, to: to.to_i)
    end

    def read_stacks(stack_string)
      lines = stack_string.split("\n")
      stack_count = lines[-1][-1].to_i
      stacks = Array.new(stack_count) { [] }

      rows =
        lines[0..-2]
          .map { |line| line.gsub(/\[(.)\] ?/,'\1').gsub("    ",".") }
          .map { |line| line.ljust(stack_count, ".").chars }

      pp rows

      rows.reverse.each do |row|
        row.each_with_index do |item, index|
          stacks[index].push(item) unless item == "."
        end
      end

      stacks
    end
  end
end
