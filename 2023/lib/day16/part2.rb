require 'csv'
require 'pp'

module Day16
  class Part2
    U = [-1,0]
    D = [1,0]
    R = [0,1]
    L = [0,-1]


    NEXT_DIRS = {
      "*" => {
        U => [],
        D => [],
        L => [],
        R => [],
      },
      "/" => {
        U => [R],
        D => [L],
        L => [D],
        R => [U],
      },
      "\\" => {
        U => [L],
        D => [R],
        L => [U],
        R => [D],
      },
      "-" => {
        U => [L,R],
        D => [L,R],
        L => [L],
        R => [R],
      },
      "|" => {
        U => [U],
        D => [D],
        L => [U,D],
        R => [U, D],
      },
    }

    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      w = lines[0].length
      h = lines.length

      elems = build_elems(lines, w, h)

      side_max = (0...h).flat_map do |y|
        [
          energized([y,-1],R,elems),
          energized([y,w],L,elems),
        ]
      end.max

      vert_max = (0...w).flat_map do |x|
        [
          energized([-1,x],D,elems),
          energized([h,x],U,elems),
        ]
      end.max

      [side_max, vert_max].max
    end

    def energized(start, dir, elems)
      visited = Set.new
      energized = Set.new
      fringe = [
        [start, dir]
      ]

      while fringe.any? do
        pos, dir = fringe.shift
        next unless visited.add?([pos, dir])

        new_pos = move(pos, dir)
        new_dirs =
          if elems[new_pos]
            NEXT_DIRS[elems[new_pos]][dir]
          else
            [dir]
          end

        new_dirs.each do |new_dir|
          fringe << [new_pos, new_dir]
          energized.add(new_pos)
        end
      end

      energized.size
    end

    def build_elems(lines, w, h)
      elems = {}

      lines.each_with_index do |l, y|
        l.chars.each_with_index do |c, x|
          elems[[y,x]] = c unless c == "."
        end
      end

      # Make some "walls" at boundaries
      (0...w).each { |x| elems[[-1, x]] = "*"; elems[[h, x]] = "*"}
      (0...h).each { |y| elems[[y, -1]] = "*"; elems[[y, w]] = "*"}

      elems
    end

    def move(pos, dir)
      [pos[0]+dir[0], pos[1]+dir[1]]
    end

    def display(elems,energized,w,h)
      o = 0
      (-o...(h+o)).each do |y|
        out = ""
        (-o...(w+o)).each do |x|
          elem = elems[[y,x]]
          if energized.include?([y,x])
            out << "#"
          else
            out << (elem ? elem : ".")
          end
        end
        puts out
      end
    end
  end
end
