require 'csv'
require 'pp'

module Day6
  class Part2
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
      start_pos = nil
      start_dir = [-1,0]

      (0...h).each do |y|
        (0...w).each do |x|
          obsactles.add([y,x]) if lines[y][x] == "#"
          start_pos = [y,x] if lines[y][x] == "^"
        end
      end
      
      # Find initial path to use as potential places to put obstacles
      _, visited = simulate(start_pos, start_dir, obsactles, w, h)
      options = Set.new(visited.map(&:first)).delete(start_pos)

      # For each candidate obstacle position, count if it makes a loop
      options.count do |o_pos|
        simulate(start_pos, start_dir, obsactles.dup.add(o_pos), w, h).first
      end
    end

    def simulate(pos, dir, obsactles, w, h)
      visited = Set.new([[pos,dir]])
      loopy = false

      loop do 
        next_pos = [pos[0]+dir[0], pos[1]+dir[1]]
        
        if obsactles.include?(next_pos)
          dir = next_dir(dir)
        else
          break unless next_pos[0] >= 0 && next_pos[0] < h && next_pos[1] >= 0 && next_pos[1] < w
          pos = next_pos
          return [true, visited] if visited.include?([pos, dir])
          visited.add([pos,dir])
        end
      end

      [false, visited]
    end

    def next_dir(dir)
      [dir[1],-1*dir[0]]
    end
  end
end
