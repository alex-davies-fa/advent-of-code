require 'csv'
require 'pp'

module Day24
  class Part2
    X = 0; Y = 1; Z = 2;
    POINT = 0; DIR = 1;

    def run(input_file)
      lines = File.readlines(input_file, chomp: true)
      hails = lines.map do |l|
        vals = l.scan(/[\-0-9]+/).map(&:to_i)
        [vals[0..2],vals[3..-1]]
      end

      p0 = ["a","b","c"]
      d = ["j","k","l"]
      t = ["t","u","v"]

      # We only need three hails to specifiy the solution.
      # For each hail, we know that a + t*v = p0 + t*d, where p0 is the starting point of our rock and d is its
      # direction.
      # We're lazy here and just dump out the 9 equalities from the first three hails, and plug them into an
      # solver e.g.
      # https://quickmath.com/webMathematica3/quickmath/equations/solve/advanced.jsp
      hails[0..2].each_with_index do |h,hi|
        (0..2).each do |i|
          puts "#{h[POINT][i]}+#{t[hi]}*#{h[DIR][i]} = #{p0[i]}+#{t[hi]}*#{d[i]}"
        end
      end

      nil
    end
  end
end
