require 'csv'
require 'pp'

module Day9
  class Part1
    def run(input_file)
      disk = read_disk(input_file)

      p1 = 0
      p2 = disk.keys.max

      while p1 < p2
        while !disk[p1].nil?
          p1 += 1
        end
        while disk[p2].nil? && p2 > p1
          p2 -= 1
        end

        if !disk[p2].nil? && disk[p1].nil?
          disk[p1] = disk[p2]
          disk[p2] = nil
        end
      end

      disk.map { |k,v| v.nil? ? 0 : k*v }.sum
    end

    def read_disk(input_file)
      input = File.read(input_file)

      disk = {}

      type = 1
      files_index = 0
      pointer = 0

      input.chars.map(&:to_i).map do |val|
        if type == 1
          val.times do
            disk[pointer] = files_index
            pointer += 1
          end
          files_index += 1
        else
          val.times do
            disk[pointer] = nil
            pointer += 1
          end
        end
        type *= -1
      end

      disk
    end
  end
end
