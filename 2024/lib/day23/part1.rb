require 'csv'
require 'pp'

module Day23
  class Part1
    def run(input_file)
      edges = Hash.new { |h,k| h[k] = Set.new }

      File.readlines(input_file).map{ _1.strip.split("-") }.each do |s,e|
        edges[s].add(e)
        edges[e].add(s)
      end

      triplets = Set.new
      edges.keys.filter { _1.start_with?('t') }.each do |start|
        neighbours = edges[start]
        neighbours.each do |neighbour|
          seconds = edges[neighbour]
          seconds.each do |second|
            if edges[second].include?(start)
              triplets.add([start,neighbour,second].sort)
            end
          end
        end
      end

      triplets.length
    end
  end
end
