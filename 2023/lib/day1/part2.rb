require 'csv'
require 'pp'

module Day1
  class Part2

    NUMBERS = {
      "one" => 1,
      "two" => 2,
      "three" => 3,
      "four" => 4,
      "five" => 5,
      "six" => 6,
      "seven" => 7,
      "eight" => 8,
      "nine" => 9,
      "1"=> 1,
      "2"=> 2,
      "3"=> 3,
      "4" => 4,
      "5" => 5,
      "6" => 6,
      "7" => 7,
      "8" => 8,
      "9" => 9
    }

    def run(input_file)
      data = File.readlines(input_file).map(&:strip)
      total = 0

      data.each do |line|
        first_digit = nil
        (0..line.length).each do |len|
          NUMBERS.each do |str, val|
            if line[0..len].include?(str)
              first_digit = val
              break
            end
          end
          break if first_digit
        end

        last_digit = nil
        (1..line.length).each do |len|
          NUMBERS.each do |str, val|
            if line[-len..-1].include?(str)
              last_digit = val
              break
            end
          end
          break if last_digit
        end

        total += first_digit*10 + last_digit
      end

      pp total

      nil
    end
  end
end
