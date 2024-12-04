require 'csv'
require 'pp'

module Day4
  class Part1
    def run(input_file)
      lines = File.readlines(input_file)
      chars = lines.map(&:chars)
      transposed_lines = chars.transpose.map(&:join)

      h = chars.length
      w = chars[0].length
      start_points = ((0..h-1).map { |p| [p,0] }) + (1..w-1).map { |p| [0,p] }.uniq
      d_lines1 = start_points.map { |x,y| diagonal_from(x,y,chars) }
      d_lines2 = start_points.map { |x,y| diagonal_from(x,y,chars.map(&:reverse)) }
      
      all_lines = [
        lines, lines.map(&:reverse),
        transposed_lines, transposed_lines.map(&:reverse),
        d_lines1, d_lines1.map(&:reverse),
        d_lines2, d_lines2.map(&:reverse),
      ].flatten

      all_lines.map { |l| count_in_line(l) }.sum
    end

    def count_in_line(line)
      line.scan(/XMAS/).length
    end

    def diagonal_from(x,y,chars)
      out = [chars[x][y]]
      loop do
        x += 1
        y +=1
        break if x >= chars.length || y >= chars[0].length
        out << chars[x][y]
      end

      out.join
    end
  end
end
