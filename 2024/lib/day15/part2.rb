require 'csv'
require 'pp'

module Day15
  class Part2
    DIRS = {
      '<' => [-1,0],
      '>' => [1,0],
      '^' => [0,-1],
      'v' => [0,1],
    }

    ANIMATE = true

    def run(input_file)
      pos, map, dirs = read_input(input_file)

      t = 0
      dirs.each do |d|
        if ANIMATE
          display(map, pos, 20, 10)
          sleep 0.1
        end

        new_pos = add(pos,d)

        if !map.key?(new_pos)
          pos = new_pos
        elsif map[new_pos] == :wall
          next
        else
          box_pos = map[new_pos]

          shifted_map = map.dup
          box_pos.each { shifted_map.delete(_1) }

          if shift?(shifted_map, box_pos, d)
            pos = new_pos
            map = shifted_map
          end
        end
      end


      map.filter { _2 != :wall && _1 == _2[0] }.sum { |p,v| p[0]+100*p[1] }
    end

    def shift?(map, box_pos, d)
      # Check where we're moving the box, and bail if we hit a wall
      new_box_pos = box_pos.map { add(_1,d) }
      return false if new_box_pos.any? { map[_1] == :wall }
      
      pushed_boxes = new_box_pos.map { map[_1] }.uniq.compact.reject { _1 == :wall} # Find pushed boxes
      pushed_boxes.each { |b| b.each { map.delete(_1) } } # Remove all positions of pushed boxes from map
      new_box_pos.each { map[_1] = new_box_pos } # Move current box
      
      # No more pushed boxes - we've successully moved the whole stack
      return true if pushed_boxes.empty?

      # More boxes to push - shift each one recursively, and return true if none hit a wall
      pushed_boxes.map { shift?(map, _1, d) }.inject { _1 && _2 }
    end

    def add(a,b)
      [a[0]+b[0],a[1]+b[1]]
    end

    def display(map, pos, w, h)
      puts
      (0...h).each do |y|
        l = ""
        (0...w).each do |x|
          if map[[x,y]] == :wall
            l << '#'
          elsif pos == [x,y]
            l << '@'
          elsif map[[x,y]].nil?
            l << '.'
          else
            b1,b2 = map[[x,y]]
            l << (b1 == [x,y] ? "[" : "]")
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
            map[[x*2,y]] = :wall
            map[[x*2+1,y]] = :wall
          when 'O'
            box = [[x*2,y],[x*2+1,y]]
            map[[x*2,y]] = box
            map[[x*2+1,y]] = box
          when '@'
            pos = [x*2,y]
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
