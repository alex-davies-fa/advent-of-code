require 'csv'
require 'pp'

module Day18
  class Part2
    def run(input_file)
      coords =
        File.readlines(input_file, chomp: true)
          .map { |l| l.split(',').map(&:to_i) }

      map = Hash.new {|h,k| h[k] = h.class.new(&h.default_proc) }

      coords.each do |x,y,z|
        map[x][y][z] = 1
      end

      min_x = coords.min_by { _1[0] }[0]
      max_x = coords.max_by { _1[0] }[0]
      min_y = coords.min_by { _1[1] }[1]
      max_y = coords.max_by { _1[1] }[1]
      min_z = coords.min_by { _1[2] }[2]
      max_z = coords.max_by { _1[2] }[2]

      pocket_candidates = Set.new
      dirs = [-1,0,1].repeated_permutation(3).filter { |p| p.map(&:abs).sum == 1 }

      # Find candidate pockets, i.e. all empty spaces next to a rock space
      for x,y,z in coords
        for dx,dy,dz in dirs
          pocket_candidates << [x+dx,y+dy,z+dz] if map[x+dx][y+dy][z+dz] != 1
        end
      end

      # Loop through each candidate pocket, flood filling outwards until we either:
      # - Hit the bounds of the rock (implying we've escaped to clear air)
      # - Empty out queue (impplying we've found an isolated pocket)
      # If it's a pocket, "fill in" all the cubes in our original map
      pocket_candidates.each do |candidate|
        queue = [candidate]
        pocket = Set.new([candidate])
        is_pocket = true

        while (x,y,z = queue.shift)
          if x >= max_x || x <= min_x || y >= max_y || y <= min_y || z >= max_z || z <= min_z
            # Reached the end - discard this set
            is_pocket = false
            break
          end

          for dx,dy,dz in dirs
            # No rock in this direction - add to queue
            if map[x+dx][y+dy][z+dz] != 1
              space = [x+dx,y+dy,z+dz]
              if pocket.add?(space) # Add to pocket
                queue << space # Add to queue if we've not seen it before
              end
            end
          end
        end

        if is_pocket
          # "Fill in" each cube of the pocket in our map of rock positions
          pocket.each do |x,y,z|
            map[x][y][z] = 1
          end
        end
      end

      # Count up surface area as before after "filling" gaps
      surface = 0
      for x,y,z in coords
        surface += 6
        for dx,dy,dz in dirs
          surface -= 1 if map[x+dx][y+dy][z+dz] == 1
        end
      end

      nil
    end
  end
end
