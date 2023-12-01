require 'csv'
require 'pp'

module Day1
  class Part1
    def run(input_file)
      data = File.readlines(input_file)
      total = 0
      data.each do |line|
        digits = line.split("").select { |c| c =~ /\d/ }
        total += (digits.first + digits.last).to_i
      end

      pp total

      nil
    end
  end
end
