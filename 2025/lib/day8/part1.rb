require 'csv'
require 'pp'

module Day8
  class Part1
    N = 1000

    def run(input_file)
      ps = File.readlines(input_file).map { |l| l.split(",").map(&:to_i) }

      dists = 
        ps.combination(2)
          .map { |p1,p2| [p1,p2,dist(p1,p2)] }
          .sort_by { _1[2] }

      closest = dists.first(N)
      
      circuits = ps.map { [_1, Set.new([_1])] }.to_h
      
      closest.each do |p1,p2,_|
        new_circuit = circuits[p1].union(circuits[p2])
        new_circuit.each { circuits[_1] = new_circuit }
      end

      circuits.values.uniq.map(&:length).sort.last(3).inject(&:*)
    end

    def dist(p1,p2)
      Math.sqrt((p1[0]-p2[0])**2 + (p1[1]-p2[1])**2 + (p1[2]-p2[2])**2)
    end
  end
end
