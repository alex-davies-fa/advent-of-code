require 'csv'
require 'pp'

module Day5
  class Part2
    def run(input_file)
      input = File.read(input_file)
      seeds = input.split("\n")[0].scan(/\d+/).map(&:to_i)
      stages = get_maps(input)

      seed_ranges =
        seeds.each_slice(2).map do |start, range|
          (start..start+range)
        end

      stage_ranges = seed_ranges

      stages.each do |stage|
        next_stage_ranges = []
        stage_ranges.each do |range|
          stage.each do |transformation|
            # Find the overlap of each of our existing ranges and the transformations
            overlap = range_overlap(transformation[:source_range], range)
            next unless overlap
            # Shift the overlapping part of our range according to its destination
            offset = transformation[:dest_start] - transformation[:source_range].begin
            new_range = (overlap.begin + offset)..(overlap.end + offset)
            next_stage_ranges << new_range
          end
        end
        stage_ranges = next_stage_ranges
      end

      stage_ranges.map { _1.begin }.min
    end

    def range_overlap(r1, r2)
      return nil if (r1.max < r2.begin or r2.max < r1.begin)
      [r1.begin, r2.begin].max..[r1.max, r2.max].min
    end

    def get_maps(input)
      maps = {}

      input.split("\n\n")[1..].map do |section|
        lines = section.split("\n")
        from, to = lines[0].scan(/(\w+)-to-(\w+)/)[0]

        transforms = lines[1..].map do |line|
          dest_start, source_start, range = line.scan(/\d+/).map(&:to_i)
          source_range = source_start..(source_start + range)
          { source_range: , dest_start: }
        end

        # Order by start
        transforms = transforms.sort_by { |t| t[:source_range].begin }

        # Fill in gaps -
        #   0-first range
        if transforms[0][:source_range].begin > 0
          transforms.prepend({source_range: 0..transforms[0][:source_range].begin, dest_start: 0})
        end

        #   Any internal gaps
        transforms.each_with_index do |t, i|
          break if i == transforms.length - 1
          if transforms[i][:source_range].end != transforms[i+1][:source_range].begin
            transforms.insert(
              i+1,
              {source_range: transforms[i][:source_range].end..transforms[i+1][:source_range].begin, dest_start: transforms[i][:source_range].end}
            )
          end
        end

        #   last range - "infinity" (lol)
        transforms.append({source_range: transforms[-1][:source_range].end..99999999999, dest_start: transforms[-1][:source_range].end})

        transforms
      end
    end
  end
end
