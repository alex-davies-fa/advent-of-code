require 'csv'
require 'pp'

module Day9
  class Part1
    def run(input_file)
      lines = File.readlines(input_file)
      seqs = lines.map { _1.split.map(&:to_i) }

      seq_derivs = seqs.map do |seq|
        derivs = [seq]
        while derivs[-1].any? { _1 != 0 }
          derivs << derivs[-1].each_cons(2).map { -_1.inject(:-)}
        end
        derivs
      end

      seq_derivs.each do |derivs|
        diff = 0
        derivs = derivs.reverse
        (1...derivs.length).each do |i|
          derivs[i] << derivs[i][-1] + derivs[i-1][-1]
        end
      end

      seq_derivs.map(&:first).map(&:last).sum
    end
  end
end
