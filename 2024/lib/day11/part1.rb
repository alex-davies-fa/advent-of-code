require 'csv'
require 'pp'

module Day11
  class Part1
    def run(input_file)
      nums = File.read(input_file).strip.split

      25.times do
        nums = nums.map do |n|
          if n == '0'
            '1'
          elsif (n.length % 2) == 0
            h = n.length/2
            [n[0..h-1],n[h..-1].to_i.to_s]
          else
            (n.to_i * 2024).to_s
          end
        end
        nums.flatten!
      end

      nums.length
    end
  end
end
