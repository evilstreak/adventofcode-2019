require_relative 'orbit'

input = $stdin.read.split(/\n/)

orbit_map = OrbitMap.new(input)

you = orbit_map.objects.fetch("YOU")
santa = orbit_map.objects.fetch("SAN")

puts "Distance from YOU to SAN: ", you.distance_from(santa)
