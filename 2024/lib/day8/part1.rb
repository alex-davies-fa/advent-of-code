require 'csv'
require 'pp'

module Day8
  class Part1
    def run(input_file)
      lines = File.readlines(input_file).map { _1.strip.chars }
      h = lines.length
      w = lines[0].length
      
      antenna = Hash.new { |h,k| h[k] = [] }

      (0...h).each do |y|
        (0...w).each do |x|
          next if lines[y][x] == "."
          antenna[lines[y][x]] << [y,x]
        end
      end

      locations = Set.new
      antenna.values.each do |positions|
        positions.permutation(2) do |a,b|
          d = [b[0]-a[0],b[1]-a[1]]
          locations << [a[0]-d[0],a[1]-d[1]]
          locations << [b[0]+d[0],b[1]+d[1]]
        end
      end

      locations.filter { |y,x| y >= 0 && y < h && x >=0 && x < w }.length
    end
  end
end
