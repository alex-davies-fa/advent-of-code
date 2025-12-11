require 'csv'
require 'pp'

module Day11
  class Part2
    def run(input_file)
      lines = File.readlines(input_file)
      nodes = Hash.new { |h,k| h[k] = [] }
      lines.each do |l|
        start, out = l.chomp.split(": ")
        out.split(" ").each { |o| nodes[start] << o }
      end

      srv_to_fft = count_paths(nodes, "svr", "fft")
      fft_to_dac = count_paths(nodes, "fft", "dac")
      dac_to_out = count_paths(nodes, "dac", "out")
      svr_to_dac = count_paths(nodes, "svr", "dac")
      dac_to_fft = count_paths(nodes, "dac", "fft")
      fft_to_out = count_paths(nodes, "fft", "out")

      srv_to_fft * fft_to_dac * dac_to_out + svr_to_dac * dac_to_fft * fft_to_out
    end

    def count_paths(nodes, start, target, visited = {})
      return 1 if start == target

      nodes[start].map do |n|
        visited[n] = visited[n] || count_paths(nodes, n, target, visited)
      end.sum
    end
  end
end
