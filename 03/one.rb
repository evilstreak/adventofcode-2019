require_relative 'wires'

wire1, wire2 = $stdin.read.split(/\n/)

wire1 = wire1.split(/,/)
wire2 = wire2.split(/,/)

distance = closest_crossing(wire1, wire2)

puts "Distance of closest crossing: ", distance
