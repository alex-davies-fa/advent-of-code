#!/usr/bin/ruby

require 'net/http'
require 'cgi'
require 'fileutils'

day = ARGV[0]

# Copy template files to dayX directory

templates = Dir["./lib/dayx/*"]
day_dir = "./lib/day#{day}/"
Dir.mkdir(day_dir)
templates.each do |filename|
  FileUtils.cp(filename, day_dir)
end

# Fetch input

uri = URI("https://adventofcode.com/2025/day/#{day}/input")
req = Net::HTTP::Get.new(uri)

session_key = File.read(".session").strip
session_cookie = CGI::Cookie.new("session", session_key)
req['Cookie'] = session_cookie.to_s

res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) {|http|
  http.request(req)
}

input_file = day_dir + "/input.final"
File.write(input_file, res.body)
