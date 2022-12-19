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

      @leaf_count = 0
      @max = 0

      counts = blueprints.each_with_index.map { puts "Blueprint #{_2+1}"; val = calculate_val(_1); puts val; val }

      puts
      pp counts
      pp counts.each_with_index.map { |c,i| c*(i+1) }.sum

      nil
    end

    def calculate_val(b)
      @max = 0

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
      if time >= MINS
        # @leaf_count += 1
        # puts @leaf_count if @leaf_count % 1000000 == 0
        # if resources[:geode] > @max
        #   @max = resources[:geode]
        #   pp "New max: #{@max}"
        #   # pp path
        #   # puts
        # end
        return resources[:geode]
      end

      next_robot_options = [:clay, :ore]
      next_robot_options << :obsidian if robots[:clay] > 0
      next_robot_options << :geode if robots[:obsidian] > 0

      next_robot_options.map do |new_robot|
        new_resources = resources.clone
        new_robots = robots.clone
        new_time = time

        while !add_robot?(b, new_robot, new_robots, new_resources) && new_time + 1 < MINS
          new_time += 1
          new_resources.keys.each { |r| new_resources[r] += robots[r] }
        end

        new_time += 1
        new_resources.keys.each { |r| new_resources[r] += robots[r] }

        new_state = [new_resources, new_robots, new_time]

        if visited.add?(new_state)
          # new_path = path.clone << "Time: #{new_time}, Build: #{new_robot}"
          dfs(b, new_resources, new_robots, new_time, visited, nil)
        else
          0
        end
      end
        .max
    end

    def add_robot?(b, robot, robots, resources)
      if robot == :geode
        if resources[:ore] >= b.geode_cost_ore && resources[:obsidian] >= b.geode_cost_obsidian
          resources[:ore] -= b.geode_cost_ore
          resources[:obsidian] -= b.geode_cost_obsidian
          return robots[:geode] += 1
        else
          return false
        end
      end

      if robot == :obsidian
        if resources[:ore] >= b.obsidian_cost_ore && resources[:clay] >= b.obsidian_cost_clay
          resources[:ore] -= b.obsidian_cost_ore
          resources[:clay] -= b.obsidian_cost_clay
          return robots[:obsidian] += 1
        else
          return false
        end
      end

      if robot == :clay
        if resources[:ore] >= b.clay_cost_ore
          resources[:ore] -= b.clay_cost_ore
          return robots[:clay] += 1
        else
          return false
        end
      end

      if robot == :ore
        if resources[:ore] >= b.ore_cost_ore
          resources[:ore] -= b.ore_cost_ore
          return robots[:ore] += 1
        else
          return false
        end
      end
    end

    def parse_line(line)
      w = line.split.map(&:to_i)
      Blueprint.new(
        w[6],w[12],w[18],w[21],w[27],w[30]
      )
    end
  end
end
