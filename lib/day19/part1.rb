require 'csv'
require 'pp'

module Day19
  Blueprint = Struct.new(
    :ore_cost_ore,
    :clay_cost_ore,
    :obsidian_cost_ore,
    :obsidian_cost_clay,
    :geode_cost_ore,
    :geode_cost_obsidian
  )

  class Part1
    MINS = 24

    def run(input_file)
      blueprints = File.readlines(input_file).map { parse_line(_1) }
      pp blueprints

      counts = blueprints.map { calculate_val(_1) }

      puts
      pp counts
      pp counts.each_with_index.map { |c,i| c*(i+1) }.sum

      nil
    end

    def calculate_val(b)
      robots = {
        ore: 1,
        clay: 0,
        obsidian: 0,
        geode: 0
      }

      resources = {
        ore: 0,
        clay: 0,
        obsidian: 0,
        geode: 0
      }

      puts

      MINS.times do
        new_robot =
          if resources[:ore] >= b.geode_cost_ore && resources[:obsidian] >= b.geode_cost_obsidian
            resources[:ore] -= b.geode_cost_ore
            resources[:obsidian] -= b.geode_cost_obsidian
            :geode
          elsif resources[:ore] >= b.obsidian_cost_ore && resources[:clay] >= b.obsidian_cost_clay
            resources[:ore] -= b.obsidian_cost_ore
            resources[:clay] -= b.obsidian_cost_clay
            :obsidian
          elsif resources[:ore] >= b.clay_cost_ore
            resources[:ore] -= b.clay_cost_ore
            :clay
          elsif resources[:ore] >= b.ore_cost_ore
            resources[:ore] -= b.ore_cost_ore
            :ore
          end

        puts "resources"
        pp resources
        puts "robots"
        pp robots
        puts

        resources.keys.each { |r| resources[r] += robots[r] }
        robots[new_robot] +=1 if new_robot
      end

      resources[:geode]
    end

    def parse_line(line)
      w = line.split.map(&:to_i)
      Blueprint.new(
        w[6],w[12],w[18],w[21],w[27],w[30]
      )
    end
  end
end
