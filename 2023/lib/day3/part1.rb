require 'csv'
require 'pp'

module Day3
  class Part1
    def run(input_file)
      lines = File.readlines(input_file)
      schematic = lines.map { _1.split("") }

      current = ""
      current_pos = []
      symbols = []
      numbers = []

      (0...schematic.length).each do |y|
        (0...schematic[y].length).each do |x|
          char = schematic[y][x]

          if char =~ /\d/
            current += char
            current_pos << [y,x]
          else
            if !current.empty?
              numbers << [current.to_i, current_pos]
              current = ""
              current_pos = []
            end
            if ![".","\n"].include?(char)
              symbols << [y,x]
            end
          end

        end
      end

      total = 0

      numbers.each do |number, positions|
        valid = false
        symbols.each do |sy,sx|
          positions.each do |py,px|
            if (py-sy).abs <= 1 && (px-sx).abs <= 1
              valid = true
              break
            end
          end
          break if valid
        end

        total += number if valid
      end

      total
    end
  end
end
