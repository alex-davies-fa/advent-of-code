require 'csv'
require 'pp'

module Day13
  class Part1
    def run(input_file)
      sections = File.read(input_file).split("\n\n")

      m = sections.map do |s|
        pp mirror_pos(s.split("\n").map(&:strip))
      end

      m.sum { |v,h|  v + 100*h }

    end

    def mirror_pos(lines)
      rows = []
      cols = []

      lines.each_with_index do |line, y|
        line.split('').each_with_index do |c, x|
          rows[y] = [] unless rows[y]
          cols[x] = [] unless cols[x]
          rows[y] << c
          cols[x] << c
        end
      end

      v_mirror = 0
      (1...rows[0].length).each do |s|
        if rows.all? { |r| mirrors?(r[0...s],r[s..-1]) }
          v_mirror = s
          break
        end
      end

      h_mirror = 0
      (1...cols[0].length).each do |s|
        if cols.all? { |c| mirrors?(c[0...s],c[s..-1]) }
          h_mirror = s
          break
        end
      end

      [v_mirror, h_mirror]
    end

    def mirrors?(a,b)
      len = [a.length, b.length].min
      a[-len..-1] == b[0...len].reverse
    end
  end
end
