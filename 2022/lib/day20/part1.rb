require 'csv'
require 'pp'

module Day20
  class Part1
    def run(input_file)
      numbers = File.readlines(input_file).map(&:to_i)
      indeces = (0...numbers.length).to_a

      n = numbers.length

      # pp n
      # pp numbers.max
      # pp numbers.min
      # return

      debug = false

      pp numbers if debug
      pp indeces if debug
      puts if debug

      (0...n).each do |i|
        ind = indeces.find_index(i)
        number = numbers[ind]

        puts "#{i} -> #{ind} = #{number}" if debug
        pp numbers if debug

        loops, candidate_ind = (ind + number).divmod(n)
        new_ind = candidate_ind + loops

        if new_ind < ind
          numbers.delete_at(ind)
          numbers.insert(new_ind, number)
          old_ind = indeces.delete_at(ind)
          indeces.insert(new_ind, old_ind)
        else
          old_ind = indeces.delete_at(ind)
          indeces.insert(new_ind, old_ind)
          numbers.delete_at(ind)
          numbers.insert(new_ind, number)
        end

        pp numbers if debug
        puts if debug
      end

      z = numbers.find_index(0)
      positions = [z+1000, z+2000, z+3000].map { _1 % n }
      pp numbers.values_at(*positions)
      puts numbers.values_at(*positions).sum
      nil
    end
  end
end
