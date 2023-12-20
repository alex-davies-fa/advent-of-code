require 'csv'
require 'pp'

module Day20
  class Part1
    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      # Give broadcaster the same form as everything else for simplicity
      bi = lines.each { _1.gsub!("broad", "#broad") }

      modules = parse_modules(lines)

      low = 0
      high = 0

      1000.times do
        # [[module, source, pulse], ...]
        fringe = [["broadcaster", "button", false]]
        while fringe.any?
          m, s, p = fringe.shift
          p ? high += 1 : low += 1
          fringe = fringe + apply(m,s, p, modules)
        end
      end

      low*high
    end

    def apply(m, s, p, modules)
      return [] unless modules[m]
      modules[m] => {type:, dests:, state:} # Rightward assignment woo
      case type
      when "#"
        dests.map { |d| [d,m,p] }
      when "%"
        return [] if p
        modules[m][:state] = !state
        dests.map { |d| [d,m,!state] }
      when "&"
        state[s] = p
        dests.map { |d| [d,m,!state.values.all?] }
      end
    end

    def parse_modules(lines)
      modules = {}
      lines.each do |l|
        type, name, *dests = l.scan(/[%&#]|[a-z]+/)
        state = false if type == "%"
        if type == "&"
          inputs = lines.filter { _1.include?(name) }.map { _1.scan(/[a-z]+/)[0] } - [name]
          state = {}
          inputs.each { state[_1] = false }
        end

        modules[name] = { type:, dests:, state: }
      end

      modules
    end
  end
end
