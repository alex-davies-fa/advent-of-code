require 'csv'
require 'pp'

module Day3
  class Part2
    def run(input_file)
      lines = File.readlines(input_file)
      schematic = lines.map { _1.split("") }

      current = ""
      current_pos = []
      gears = []
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
            if char == "*"
              gears << [y,x]
            end
          end

        end
      end

      total = 0

      gears.each do |gy,gx|
        adj = []
        numbers.each do |number, positions|
          positions.each do |py, px|
            if (py-gy).abs <= 1 && (px-gx).abs <= 1
              adj << number
              break
            end
          end
        end

        if adj.length == 2
          total += adj[0]*adj[1]
        end
      end

      total
    end
  end
end
