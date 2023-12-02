require 'csv'
require 'pp'

module Day2
  class Part2

    def run(input_file)
      games = File.readlines(input_file)
      total = 0

      games.each_with_index do |game, index|
        maxes = {
          "red" => 0,
          "green" => 0,
          "blue" => 0,
        }

        valid = true
        handfuls = game.split(":")[1].split(";").map(&:strip)
        handfuls.each do |handful|
          colours = handful.split(",")
          colours.each do |colour_count|
            count, colour = colour_count.split(" ")
            if count.to_i > maxes[colour]
              maxes[colour] = count.to_i
            end
          end
        end

        total += maxes.values.inject(:*)
      end

      total
    end
  end
end
