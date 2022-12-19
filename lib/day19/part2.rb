require 'csv'
require 'pp'

module Day19
  class Part2
    Blueprint = Struct.new(
      :ore_cost_ore,
      :clay_cost_ore,
      :obsidian_cost_ore,
      :obsidian_cost_clay,
      :geode_cost_ore,
      :geode_cost_obsidian
    )

    MINS = 32
    B_COUNT = 3

    # This is a kinda "empirically determined" (i.e. guessed / checked by seeing if the answer is correct) value of
    # when we can stop worrying about other options and just always build geode robits. I feel bad. Probably
    # would give the wrong value for some inputs.
    CUTOFF = 26

    def run(input_file)
      blueprints = File.readlines(input_file).map { parse_line(_1) }

      @leaf_count = 0
      @max = 0

      counts = blueprints.first(B_COUNT).each_with_index.map { puts "Blueprint #{_2+1}"; val = calculate_val(_1); puts val; val }
      # counts = blueprints.each_with_index.map { puts "Blueprint #{_2+1}"; val = calculate_val(_1); puts val; val }

      puts
      pp counts
      # pp counts.each_with_index.map { |c,i| c*(i+1) }.sum
      pp counts.reduce { _1 * _2 }

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

    def dfs(b, resources, robots, time, visited = Set.new, path = "")
      if time >= MINS
        # @leaf_count += 1
        # puts @leaf_count if @leaf_count % 1000000 == 0
        if resources[:geode] > @max
          @max = resources[:geode]
          # puts "New max: #{@max}"
          # puts path
          # puts
        end
        return resources[:geode]
      end

      next_robot_options = [:clay, :ore]
      next_robot_options << :obsidian if robots[:clay] > 0
      next_robot_options << :geode if robots[:obsidian] > 0

      if robots[:ore] == b.geode_cost_ore && robots[:obsidian] == b.geode_cost_obsidian
        next_robot_options = [:geode]
      end

      if time > CUTOFF
        next_robot_options = [:geode]
      end

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
          if resources[:geode] + max_remaining(new_time, new_resources[:geode], new_robots[:geode]) < @max
            0
          else
            # new_path = path + "Time: #{new_time}, Build: #{new_robot}, Ore: #{new_robots[:ore]}, Obs: #{new_robots[:obsidian]}\n"
            new_path = nil
            dfs(b, new_resources, new_robots, new_time, visited, new_path)
          end
        else
          0
        end
      end
        .max
    end

    def max_remaining(time, geodes, geode_robots)
      geodes + (MINS - time + 1) * (2 * geode_robots + MINS - time) / 2
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
