require 'csv'
require 'pp'

module Day2
  class Part1

    MAX_COLOURS = {
      "red" => 12,
      "green" => 13,
      "blue" => 14,
    }

    def run(input_file)
      games = File.readlines(input_file)
      total = 0

      games.each_with_index do |game, index|
        valid = true
        handfuls = game.split(":")[1].split(";").map(&:strip)
        handfuls.each do |handful|
          colours = handful.split(",")
          colours.each do |colour_count|
            count, colour = colour_count.split(" ")
            if count.to_i > MAX_COLOURS[colour]
              valid = false
            end
          end
        end

        total += index + 1 if valid
      end

      total
    end
  end
end
