require 'csv'
require 'pp'

module Day9
  class Part2
    START = 0
    LENGTH = 1
    INDEX = 2

    def run(input_file)
      # [start, length, file_index]
      files, spaces = read_disk(input_file)

      files.reverse.each do |file|
        space = spaces.find { _1[LENGTH] >= file[LENGTH] }
        next unless space && space[START] < file[START]

        file[START] = space[START]
        space[LENGTH] -= file[LENGTH]
        space[START] += file[LENGTH]
      end

      files.map { |f| (f[START]...f[START]+f[LENGTH]).map { _1*f[INDEX] }.sum }.sum
    end

    def read_disk(input_file)
      input = File.read(input_file)

      type = 1
      files_index = 0
      pointer = 0

      files = []
      spaces = []

      input.chars.map(&:to_i).map do |val|
        if type == 1
          files.push([pointer, val, files_index])
          pointer += val
          files_index += 1
        else
          spaces.push([pointer,val])
          pointer += val
        end
        type *= -1
      end

      [files, spaces]
    end
  end
end
