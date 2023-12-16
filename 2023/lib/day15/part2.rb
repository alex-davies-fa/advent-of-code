require 'csv'
require 'pp'

module Day15
  class Part2
    def run(input_file)
      input = File.read(input_file).strip

      boxes = Hash.new { |h, k| h[k] = [] }

      input.split(",").each do |step|
        process(step, boxes)
      end

      focus_power(boxes)
    end

    def focus_power(boxes)
      boxes.each.sum do |box, lenses|
        (box+1) * lenses.each_with_index.sum { |lens, i| lens[1] * (i+1) }
      end
    end

    def process(step, boxes)
      parts = step.scan(/[a-z0-9]+/)

      case parts
      in [label, lens]
        add(label, lens.to_i, boxes)
      in [label]
        remove(label, boxes)
      end
    end

    def add(label, lens, boxes)
      box = hash(label)
      existing_lens = boxes[box].find_index { |lens| lens.first == label }
      if existing_lens
        boxes[box][existing_lens][1] = lens
      else
        boxes[box] << [label, lens]
      end
    end

    def remove(label, boxes)
      box = hash(label)
      boxes[box].delete_if { |lens| lens.first == label }
    end

    def hash(s)
      s.chars.inject(0) { |val, c| (val + c.ord) * 17 % 256 }
    end
  end
end
