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

      @leaf_count = 0
      @max = 0

      counts = blueprints.map { calculate_val(_1) }

      puts
      pp counts
      pp counts.each_with_index.map { |c,i| c*(i+1) }.sum

      nil
    end

    def calculate_val(b)
      puts "Processing blueprint"

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

      dfs(b, resources, robots, 0)
    end

    def dfs(b, resources, robots, time, visited = Set.new, path = [])
      if time == MINS
        @leaf_count += 1
        puts @leaf_count if @leaf_count % 1000000 == 0
        if resources[:geode] > @max
          @max = resources[:geode]
          pp "New max: #{@max}"
          # pp path
          puts
        end
        return resources[:geode]
      end

      robot_options = [nil]
      robot_options << :geode if resources[:ore] >= b.geode_cost_ore && resources[:obsidian] >= b.geode_cost_obsidian
      robot_options << :obsidian if resources[:ore] >= b.obsidian_cost_ore && resources[:clay] >= b.obsidian_cost_clay
      robot_options << :clay if resources[:ore] >= b.clay_cost_ore
      robot_options << :ore if resources[:ore] >= b.ore_cost_ore

      # Remove "no build" option if we can build anything
      robot_options == robot_options.compact if robot_options.length == 5

      if robots[:obsidian] == 0 && robot_options.length == 4
        robot_options = robot_options.compact
      end

      if robots[:clay] == 0 && robot_options.length == 3
        robot_options = robot_options.compact
      end

      robot_options.map do |new_robot|
        new_resources = resources.clone

        if new_robot == :geode
          new_resources[:ore] -= b.geode_cost_ore
          new_resources[:obsidian] -= b.geode_cost_obsidian
        elsif new_robot == :obsidian
          new_resources[:ore] -= b.obsidian_cost_ore
          new_resources[:clay] -= b.obsidian_cost_clay
        elsif new_robot == :clay
          new_resources[:ore] -= b.clay_cost_ore
        elsif new_robot == :ore
          new_resources[:ore] -= b.ore_cost_ore
        end

        new_resources.keys.each { |r| new_resources[r] += robots[r] }

        new_robots = robots.clone
        new_robots[new_robot] +=1 if new_robot

        new_state = [new_resources, new_robots, time+1]

        if visited.add?(new_state)
          # new_path = path.clone << "Time: #{time+1}, Build: #{new_robot}"
          dfs(b, new_resources, new_robots, time+1, visited, nil)
        else
          0
        end
      end
        .max
    end

    def parse_line(line)
      w = line.split.map(&:to_i)
      Blueprint.new(
        w[6],w[12],w[18],w[21],w[27],w[30]
      )
    end
  end
end
