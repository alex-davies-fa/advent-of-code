require 'csv'
require 'pp'

module Day19
  class Part1
    SYM_VALS = {
      "x" => 0,
      "m" => 1,
      "a" => 2,
      "s" => 3,
    }

    def run(input_file)
      workflows_s, parts_s = File.read(input_file).split("\n\n")

      workflows = parse_workflows(workflows_s)
      parts = parts_s.split("\n").map { |p| p.scan(/[0-9]+/).map(&:to_i) }

      parts.sum do |p|
        state = "in"
        while !["A", "R"].include?(state)
          state = workflows[state].find { |r| r[:rule].call(p) }[:dest]
        end

        state == "A" ? p.sum : 0
      end
    end

    def parse_workflows(workflows_s)
      workflows = {}
      workflows_s.split("\n").each do |str|
        name, rest = str.split("{")
        rules = rest[0..-1].split(",").map do |rule_str|
          sym, sign, val, dest = rule_str.scan(/[a-zA-Z]+|[><]|[0-9]+/)
          if dest.nil?
            { rule: lambda { |_| true }, dest: sym } # Fallback state
          else
            rule = lambda { |vals| vals[SYM_VALS[sym]].send(sign, val.to_i) }
            { rule:, dest: }
          end
        end
        workflows[name] = rules
      end

      workflows
    end
  end
end
