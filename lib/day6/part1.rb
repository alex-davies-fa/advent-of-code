require 'csv'
require 'pp'

module Day6
  class Part1
    def run(input_file)
      buffer = File.read(input_file)[0..-2].chars
      (3..buffer.length).each do |i|
        substring = buffer[i-3..i]
        if substring.uniq.count == 4
          pp i+1
          return
        end
      end

      nil
    end
  end
end
