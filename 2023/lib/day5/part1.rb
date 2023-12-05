require 'csv'
require 'pp'

module Day5
  class Part1
    def run(input_file)
      input = File.read(input_file)
      seeds = input.split("\n")[0].scan(/\d+/).map(&:to_i)
      stages = get_maps(input)

      locations =
        seeds.map do |seed|
          stage_val = seed
          stages.each do |stage|
            stage.each do |transform|
              if transform[:source] <= stage_val && stage_val < transform[:source] + transform[:range]
                stage_val = transform[:dest] + stage_val - transform[:source]
                break
              end
            end
          end

          stage_val
        end

        locations.min
    end

    81
    81
    81
    74
    78
    78
    82

    def get_maps(input)
      maps = {}

      input.split("\n\n")[1..].map do |section|
        lines = section.split("\n")
        from, to = lines[0].scan(/(\w+)-to-(\w+)/)[0]

        lines[1..].map do |line|
          dest, source, range = line.scan(/\d+/).map(&:to_i)
          { dest: , source: , range: }
        end
      end
    end
  end
end
