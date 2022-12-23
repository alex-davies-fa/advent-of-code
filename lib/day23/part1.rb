require 'csv'
require 'pp'
require 'matrix'
module Day23
  class Part1

    N = 10

    def run(input_file)
      elves = read_input(input_file)

      all_dirs = [-1,0,1].repeated_permutation(2).reject { _1 == [0,0] }.map{ Vector[*_1] }

      options = [
        { checks: [Vector[-1,-1], Vector[-1,0], Vector[-1,1]], dir: Vector[-1,0] },
        { checks: [Vector[1,-1], Vector[1,0], Vector[1,1]], dir: Vector[1,0] },
        { checks: [Vector[-1,-1], Vector[0,-1], Vector[1,-1]], dir: Vector[0,-1] },
        { checks: [Vector[-1,1], Vector[0,1], Vector[1,1]], dir: Vector[0,1] },
      ]

      N.times do
        moves = {}

        # Propose new positions
        for elf in elves
          moves[elf] = elf # default to no move

          # Skip if no adjacent elves
          next if all_dirs.none? { |d| elves.include?(elf + d) }

          # Consider all options in order
          for option in options
            if option[:checks].none? { |c| elves.include?(elf + c) }
              moves[elf] = elf + option[:dir]
              break
            end
          end
        end

        # Move each to new position, unless the new position is a duplicate
        duplicates = Set.new(moves.values.group_by{_1}.select { _2.size > 1 }.map(&:first))
        elves = Set.new
        moves.each do |old, new|
          elves << (duplicates.include?(new) ? old : new)
        end

        options = options.rotate
      end

      print_elves(elves)
      puts

      min, max = bounds(elves)
      pp [min, max]
      pp size = max - min
      pp (size[0]+1)*(size[1]+1)
      pp (size[0]+1)*(size[1]+1) - elves.length

      nil
    end

    def bounds(elves)
      xmin = elves.map{_1[1]}.min
      xmax = elves.map{_1[1]}.max
      ymin = elves.map{_1[0]}.min
      ymax = elves.map{_1[0]}.max

      [Vector[ymin,xmin], Vector[ymax,xmax]]
    end

    def print_elves(elves)
      b = bounds(elves)
      for y in b[0][0]..b[1][0]
        for x in b[0][1]..b[1][1]
          c = elves.include?(Vector[y,x]) ? '#' : '.'
          print c
        end
        print "\n"
      end
    end

    def read_input(input_file)
      lines = File.readlines(input_file, chomp: true).map(&:chars)
      elves = Set.new
      for y in 0...lines.length
        for x in 0...lines[y].length
          elves << Vector[y,x] if lines[y][x] == '#'
        end
      end

      elves
    end
  end
end
