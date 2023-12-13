require 'csv'
require 'pp'

module Day13
  class Part2
    NEW_VAL = {
      "." => "#",
      "#" => ".",
    }

    def run(input_file)
      sections = File.read(input_file).split("\n\n")

      patterns = sections.map { |s| s.split("\n").map(&:strip).map { _1.split("") } }

      original_mirrors = patterns.map do |p|
        mirror_pos(p).map(&:first)
      end

      smudge_mirrors = patterns.each_with_index.map do |p, i|
        alt = [0,0]
        (0...p.length).each do |y|
          (0...p[y].length).each do |x|
            val = p[y][x]
            p[y][x] = NEW_VAL[val]
            m = mirror_pos(p)
            m[0] = m[0] - [original_mirrors[i][0]]
            m[1] = m[1] - [original_mirrors[i][1]]
            alt[0] = m[0].first if m[0].any?
            alt[1] = m[1].first if m[1].any?
            p[y][x] = val
          end
        end
        alt
      end

      smudge_mirrors.sum { |v,h|  v + 100*h }
    end

    def mirror_pos(lines)
      rows = []
      cols = []

      lines.each_with_index do |line, y|
        line.each_with_index do |c, x|
          rows[y] = [] unless rows[y]
          cols[x] = [] unless cols[x]
          rows[y] << c
          cols[x] << c
        end
      end

      v_mirror = []
      (1...rows[0].length).each do |s|
        if rows.all? { |r| mirrors?(r[0...s],r[s..-1]) }
          v_mirror << s
        end
      end

      h_mirror = []
      (1...cols[0].length).each do |s|
        if cols.all? { |c| mirrors?(c[0...s],c[s..-1]) }
          h_mirror << s
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
