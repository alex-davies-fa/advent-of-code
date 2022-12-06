require 'csv'
require 'pp'

module Day1
  class Part1
    def self.run(input_file)
      parsed_input = File.read(input_file)
      counts = new.elf_counts(parsed_input)
      counts.max
    end

    def elf_counts(input)
      elves = [0]
      elf_num = 0

      input.split("\n").each do |line|
        if line.empty?
          elf_num += 1
          elves[elf_num] = 0
          next
        end

        elves[elf_num] += line.to_i
      end

      elves
    end
  end
end
