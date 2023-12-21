require 'csv'
require 'pp'

module Day19
  class Part2
    SYM_VALS = {
      "x" => 0,
      "m" => 1,
      "a" => 2,
      "s" => 3,
    }

    def run(input_file)
      workflows_s, parts_s = File.read(input_file).split("\n\n")

      workflows = parse_workflows(workflows_s)

      # Build a list of all paths that lead to accepting states, in the form [[workflow name, rule index], ...]
      accepting_paths = enumerate_paths([["in",nil]],workflows)

      # For each path, at each step filter the ranges of values for each variable which could let us take this path
      path_ranges = accepting_paths.map do |path|
        ranges = [[1,4000],[1,4000],[1,4000],[1,4000]]
        path.each do |name,rule_i|
          # We must match the /inverse/ of each rule that we /didn't/ take (before the taken rule)
          (0...rule_i).each do |i|
            rule = workflows[name][i]
            update_range_inverse!(ranges[rule[:sym]], rule[:sign], rule[:val])
          end
          # Then we must /match/ the rule we do follow
          rule = workflows[name][rule_i]
          update_range!(ranges[rule[:sym]], rule[:sign], rule[:val])
        end

        ranges
      end

      # For each path, calculate the number of combinations of variables which can take you down that path,
      # i.e. (range of x * range of m * ...), then sum for final answer
      path_ranges.sum do |ranges|
        ranges.inject(1) do |combinations, range|
          combinations * ((range[1] - range[0]) + 1)
        end
      end
    end

    # Returns a list of all /accepting/ paths, and which workflow / rule pair was taken at each step
    # (By DFS from "in" workflow)
    def enumerate_paths(path,workflows)
      next_states = workflows[path.last[0]].map { _1[:dest] }
      paths = []
      next_states.each_with_index do |s,i|
        next_path = path.map(&:dup)
        next_path[-1][1] = i # Set "rule choice" at previous step
        next_path << [s,nil]
        if s == "A"
          paths << next_path[0..-2] # Add path but drop accept state
        elsif s == "R"
          # NOOP - drop this path
        else
          enumerate_paths(next_path,workflows).each do |p|
            paths << p
          end
        end
      end

      paths
    end

    def update_range!(range, sign, val)
      if sign == ">"
        range[0] = [range[0], val+1].max
      elsif sign == "<"
        range[1] = [range[1], val-1].min
      end
    end

    def update_range_inverse!(range, sign, val)
      new_sign = sign == ">" ? "<" : ">"
      new_val = sign == ">" ? val+1 : val-1
      update_range!(range, new_sign, new_val)
    end

    def parse_workflows(workflows_s)
      workflows = {}
      workflows_s.split("\n").each do |str|
        name, rest = str.split("{")
        rules = rest[0..-1].split(",").map do |rule_str|
          sym, sign, val, dest = rule_str.scan(/[a-zA-Z]+|[><]|[0-9]+/)
          if dest.nil?
            { sym: 0, sign: ">", val: 0, dest: sym } # Dummy range for fallback caase so we don't have to special case
          else
            { sym: SYM_VALS[sym], sign: sign, val: val.to_i, dest: dest }
          end
        end
        workflows[name] = rules
      end

      workflows
    end
  end
end
