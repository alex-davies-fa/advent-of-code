require 'csv'
require 'pp'

module Day10
  class Part1
    def run(input_file)
      lines = File.readlines(input_file).map { |l| l.chomp.split(" ") }
      machines = lines.map do |l|
        lights = l[0].chars[1..-2].map { _1 == "#" }
        buttons = l[1..-2].map { _1[1..-2].split(",").map(&:to_i) }
        
        { lights:, buttons: }
      end

      machines.sum do |machine|
        shortest_seq(machine)
      end
    end

    def shortest_seq(machine)
      start_state = [false] * machine[:lights].length
      fringe = [ [start_state,[]] ]

      while state = fringe.shift
        lights, actions = state
        return actions.length if lights == machine[:lights]

        machine[:buttons].each do |button|
          fringe << [next_state(lights,button),actions.dup << button]
        end
      end

      nil
    end

    def next_state(lights,button)
      lights = lights.dup
      button.each { |i| lights[i] = !lights[i] }
      lights
    end
  end
end
