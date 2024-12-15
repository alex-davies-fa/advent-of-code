require 'csv'
require 'pp'

module Day15
  class Part1
    DIRS = {
      '<' => [-1,0],
      '>' => [1,0],
      '^' => [0,-1],
      'v' => [0,1],
    }

    def run(input_file)

      pos, map, dirs = read_input(input_file)

      dirs.each do |d|
        new_pos = add(pos,d)
        if !map.key?(new_pos)
          pos = new_pos
        elsif map[new_pos] == :wall
          next
        else
          obj_pos = new_pos
          hit_wall = false
          while map.key?(obj_pos)
            if map[obj_pos] == :wall
              hit_wall = true
              break
            end
            obj_pos = add(obj_pos,d)
          end
          if !hit_wall
            map[obj_pos] = :box
            map.delete(new_pos)
            pos = new_pos
          end
        end
      end

      # display(map, pos, 10, 10)

      map.filter { _2 == :box }.sum { |p,v| p[0]+100*p[1] }
    end

    def add(a,b)
      [a[0]+b[0],a[1]+b[1]]
    end

    def display(map, pos, h, w)
      (0...h).each do |y|
        l = ""
        (0...w).each do |x|
          if map[[x,y]] == :wall
            l << '#'
          elsif map[[x,y]] == :box
            l << 'O'
          elsif pos == [x,y]
            l << '@'
          else
            l << '.'
          end
        end
        puts l
      end
    end


    def read_input(input_file)
      map_s, dirs_s = File.read(input_file).split("\n\n")
      map = {}
      pos = nil
      lines = map_s.split("\n")
      lines.each_with_index do |l,y|
        lines[y].chars.each_with_index do |c,x|
          case c
          when '#'
            map[[x,y]] = :wall
          when 'O'
            map[[x,y]] = :box
          when '@'
            pos = [x,y]
          end
        end
      end

      dirs = []
      dirs_s.chars.each do |c|
        next unless DIRS.key?(c)
        dirs << DIRS[c]
      end

      [pos,map,dirs]
    end
  end
end
