require 'csv'
require 'pp'

module Day6
  class Part1
    DIRS = [
      [-1,0],
      [0,1],
      [1,0],
      [0,-1]
    ]

    def run(input_file)
      lines = File.readlines(input_file).map { _1.strip.chars }
      h = lines.length
      w = lines[0].length
      
      obsactles = Set.new
      pos = nil
      dir = [-1,0]

      (0...h).each do |y|
        (0...w).each do |x|
          obsactles.add([y,x]) if lines[y][x] == "#"
          pos = [y,x] if lines[y][x] == "^"
        end
      end

      visited = Set.new([pos])

      loop do 
        next_pos = [pos[0]+dir[0], pos[1]+dir[1]]
        
        if obsactles.include?(next_pos)
          dir = next_dir(dir)
        else
          pos = next_pos
          break unless pos[0] >= 0 && pos[0] < h && pos[1] >= 0 && pos[1] < w
          visited.add(pos)
        end
      end

      visited.length
    end

    def next_dir(dir)
      [dir[1],-1*dir[0]]
    end
  end
end
