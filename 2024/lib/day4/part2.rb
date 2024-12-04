require 'csv'
require 'pp'

module Day4
  class Part2
    def run(input_file)
      lines = File.readlines(input_file)
      chars = lines.map { |l| l.strip.chars }
      transposed_lines = chars.transpose.map(&:join)

      h = chars.length
      w = chars[0].length
      start_points = ((0..h-1).map { |p| [p,0] }) + (1..w-1).map { |p| [0,p] }
      reverse_start_points = ((0..h-1).map { |p| [p,w-1] }) + (1..w-1).to_a.reverse.map { |p| [0,p] }

      ps1 = start_points.flat_map { |x,y| mas_positions_from(x,y,chars) }
      ps2 = reverse_start_points.flat_map { |x,y| reverse_mas_positions_from(x,y,chars) }

      (ps1 & ps2).length
    end

    def mas_positions_from(x,y,c)
      out = []
      loop do
        test = [at(x,y,c),at(x+1,y+1,c),at(x+2,y+2,c)]
        out << [x+1,y+1] if ["MAS","SAM"].include?(test.join)

        x += 1; y +=1
        break if x >= c.length || y >= c[0].length
      end

      out
    end

    def reverse_mas_positions_from(x,y,c)
      out = []
      loop do
        test = [at(x,y,c),at(x+1,y-1,c),at(x+2,y-2,c)]
        out << [x+1,y-1] if ["MAS","SAM"].include?(test.join)

        x += 1; y -=1
        break if x >= c.length || y < 0
      end

      out
    end

    def at(x,y,c)
      return "" if x >= c.length || y >= c[0].length
      c[x][y]
    end
  end
end
