Dir[File.join(__dir__, 'lib', '**/*.rb')].each { |file| require file }

def run(day, part, final)
  runner = Object.const_get("Day#{day}::Part#{part}")

  file_end = final ? "final" : "test"
  input = "./lib/day#{day}/input.#{file_end}"

  puts "Running Day #{day} Part #{part}"
  puts runner.new.run(input)
end

day = ARGV[0]
part = ARGV[1]
final = ["final", "f"].include?(ARGV[2])
run(day, part, final)
