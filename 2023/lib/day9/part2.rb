require 'csv'
require 'pp'

module Day9
  class Part2
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
          derivs[i].prepend(derivs[i][0] - derivs[i-1][0])
        end
      end

      seq_derivs.map(&:first).map(&:first).sum
    end
  end
end
