require 'csv'
require 'pp'

module Day22
  class Part2
    class Edge
      attr_reader :v1, :v2, :d
      def initialize(v1:, v2:, d:)

        # Deep sins - I wrote my hardcode coordinates as e.g. 0-100, 100-200 instead of
        # 0-99, 100-199 etc.
        # Didn't want to fix it, so bodge it in code.
        if d == RIGHT
          v1[1] = v1[1] - 1
          v2[1] = v2[1] -1
        elsif d == DOWN
          v1[0] = v1[0] - 1
          v2[0] = v2[0] -1
        end
        v1[0] -= 1 if v1[0] > v2[0]
        v2[0] -= 1 if v2[0] > v1[0]
        v1[1] -= 1 if v1[1] > v2[1]
        v2[1] -= 1 if v2[1] > v1[1]

        @v1 = v1
        @v2 = v2
        @d = d
      end

      # For a given position and direction, are we about to step off this edge?
      def step_off?(pos, dir)
        return false unless dir == d
        (ys.min..ys.max).include?(pos[0]) && (xs.min..xs.max).include?(pos[1])
      end

      # Returns the position and direction we end up after stepping off this edge onto edge 2
      # (assuming their v1 and v2 match up)
      def match(pos, edge2)
        dist = [(v1[0]-pos[0]).abs, (v1[1]-pos[1]).abs].max
        new_pos = edge2.along(dist)
        new_dir = [edge2.d[0]*-1, edge2.d[1]*-1]
        [new_pos, new_dir]
      end

      def along(dist)
        y = v1[0] == v2[0] ? v1[0] : v1[0] + dist * (v2[0] <=> v1[0])
        x = v1[1] == v2[1] ? v1[1] : v1[1] + dist * (v2[1] <=> v1[1])
        [y.to_i,x.to_i]
      end

      def xs
        [v1[1],v2[1]]
      end

      def ys
        [v1[0],v2[0]]
      end
    end

    DIRS = [[0,1], [1,0], [0,-1], [-1,0]]

    DIR_OUT = {
      [0,-1] => "<",
      [0,1] => ">",
      [1,0] => "v",
      [-1,0] => "^",
    }

    UP = [-1,0]
    RIGHT = [0,1]
    LEFT = [0,-1]
    DOWN = [1,0]

    # Hardcode the matching "edges" in the map (worked out by hand)
    # Folding a cube in code is too much this close to Christmas
    EDGE_PAIRS_TEST = [
       [Edge.new(v1: [4,4], v2: [4,8], d: UP ),
        Edge.new(v1: [0,8], v2: [4,8], d: LEFT )],
       [Edge.new(v1: [8,4], v2: [8,8], d: DOWN ),
        Edge.new(v1: [12,8], v2: [8,8], d: LEFT )],
       [Edge.new(v1: [4,0], v2: [4,4], d: UP),
        Edge.new(v1: [0,12], v2: [0,8], d: UP)],
       [Edge.new(v1: [8,0], v2: [8,4], d: DOWN),
        Edge.new(v1: [12,12], v2: [12,8], d: DOWN)],
       [Edge.new(v1: [4,12], v2: [8,12], d: RIGHT),
        Edge.new(v1: [8,16], v2: [8,12], d: UP )],
       [Edge.new(v1: [0,12], v2: [4,12], d: RIGHT),
        Edge.new(v1: [12,16], v2: [8,16], d: RIGHT)],
       [Edge.new(v1: [12,12], v2: [12,16], d: DOWN),
        Edge.new(v1: [8,0], v2: [4,0], d: LEFT)],
    ]

    EDGE_PAIRS_FINAL = [
       [Edge.new(v1: [100,0], v2: [100,50], d: UP),
        Edge.new(v1: [50,50], v2: [100,50], d: LEFT)],
       [Edge.new(v1: [200,50], v2: [150,50], d: RIGHT),
        Edge.new(v1: [150,100], v2: [150,50], d: DOWN)],
       [Edge.new(v1: [50,100], v2: [100,100], d: RIGHT),
        Edge.new(v1: [50,100], v2: [50,150], d: DOWN)],
       [Edge.new(v1: [150,0], v2: [100,0], d: LEFT),
        Edge.new(v1: [0,50], v2: [50,50], d: LEFT)],
       [Edge.new(v1: [200,0], v2: [150,0], d: LEFT),
        Edge.new(v1: [0,100], v2: [0,50], d: UP)],
       [Edge.new(v1: [200,0], v2: [200,50], d: DOWN),
        Edge.new(v1: [0,100], v2: [0,150], d: UP)],
       [Edge.new(v1: [100,100], v2: [150,100], d: RIGHT),
        Edge.new(v1: [50,150], v2: [0,150], d: RIGHT)],
    ]

    PRINT = true

    def run(input_file)
      map, instructions = read_input(input_file)
      output_map = map.map { |r| r.clone }

      @edge_pairs = map.length == 12 ? EDGE_PAIRS_TEST : EDGE_PAIRS_FINAL

      dir = DIRS[0]

      pos = [0, map[0].find_index { |v| v != " " }]

      output_map[pos[0]][pos[1]] = DIR_OUT[dir]

      for i in instructions
        case i
        when String
          dir = turn(dir, i)
          output_map[pos[0]][pos[1]] = DIR_OUT[dir]
          print_map(output_map, pos)
        when Integer
          i.times do
            pos, dir = step(map, pos, dir)
            output_map[pos[0]][pos[1]] = DIR_OUT[dir]
            print_map(output_map, pos)
          end
        end
      end

      print_map(output_map, pos, final: true)

      puts "row: #{pos[0] + 1}\ncol: #{pos[1] + 1}\ndir: #{DIRS.find_index(dir)}"
      pp 1000 * (pos[0]+1) + 4*(pos[1]+1) + DIRS.find_index(dir)

      nil
    end

    def turn(dir, instruction)
      di = DIRS.find_index(dir)
      d = instruction == "L" ? -1 : 1
      di = (di+d) % DIRS.length
      DIRS[di]
    end

    def step(map, pos, dir)
      w = map[0].length - 1
      h = map.length - 1

      new_pos = pos
      new_dir = dir

      # Check for falling off each edge
      @edge_pairs.each do |e1, e2|
        if e1.step_off?(pos,dir)
          new_pos, new_dir = e1.match(pos,e2)
        elsif e2.step_off?(pos,dir)
          new_pos, new_dir = e2.match(pos,e1)
        end
      end

      # If our position hasn't changed (i.e we've not fallen off an edge ), just do a normal step
      if new_pos == pos
        new_pos = [pos[0] + dir[0], pos[1] + dir[1]]
      end

      # Our new position should now either be a . or a #. Panic if it isn't.
      return [new_pos,new_dir] if map[new_pos[0]][new_pos[1]] == "."
      return [pos,dir] if map[new_pos[0]][new_pos[1]] == "#"

      raise "This shouldn't happen"
    end

    def read_input(file)
      map,instructions = File.read(file).split("\n\n")

      map = map.split("\n")
      max_width = map.map(&:length).max
      map = map.map { |l| l.ljust(max_width, " ") }.map(&:chars)

      instructions = instructions.strip.split(/(L|R)/)
      instructions.map! { |i| i =~ /L|R/ ? i : i.to_i }

      [map, instructions]
    end

    def print_map(map, pos, final: false)
      return unless PRINT

      s = 8
      left = pos[1] - s
      right = pos[1] + s
      top = pos[0] - s
      bot = pos[0] + s

      sub = {
        " " => "⬜",
        "." => "⬛",
        "#" => "🟫",
        "<" => "⬅ ",
        ">" => "➜ ",
        "v" => "⬇ ",
        "^" => "⬆ ",
        nil => "⬜"
      }
      (top..bot).each do |y|
        (left..right).each do |x|
          if [y,x] == pos
            print "🐘"
          elsif y < 0 || y >= map.length || x < 0 || x >= map[0].length
            print "⬜"
          else
            print sub[map[y][x]]
          end
        end
        print "\n"
      end

      unless final
        print "\033[#{s*2+1}A"
        print "\r"

        sleep(0.05)
      end
    end
  end
end
