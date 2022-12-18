require 'csv'
require 'pp'

module Day18
  class Part1
    def run(input_file)
      coords =
        File.readlines(input_file, chomp: true)
          .map { |l| l.split(',').map(&:to_i) }

      map = Hash.new {|h,k| h[k] = h.class.new(&h.default_proc) }

      coords.each do |x,y,z|
        map[x][y][z] = 1
      end

      surface = 0
      dirs = [-1,0,1].repeated_permutation(3).filter { |p| p.map(&:abs).sum == 1 }

      for coord in coords
        surface += 6
        for dx,dy,dz in dirs
          surface -= 1 if map[coord[0]+dx][coord[1]+dy][coord[2]+dz] == 1
        end
      end

      pp surface
      nil
    end
  end
end
