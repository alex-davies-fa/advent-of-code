require 'csv'
require 'pp'

module Day6
  class Part2
    def run(input_file)
      buffer = File.read(input_file)[0..-2].chars
      (13..buffer.length).each do |i|
        substring = buffer[i-13..i]
        if substring.uniq.count == 14
          pp i+1
          return
        end
      end

      nil
    end
  end
end
