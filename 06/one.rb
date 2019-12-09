require_relative 'orbit'

input = $stdin.read.split(/\n/)

orbit_map = OrbitMap.new(input)

puts "Orbit count checksum: ", orbit_map.orbit_count_checksum
