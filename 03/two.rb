require_relative 'wires'

path1, path2 = $stdin.read.split(/\n/)

wire1 = Wire.new(path1.split(/,/))
wire2 = Wire.new(path2.split(/,/))

distance = minimal_signal_delay(wire1, wire2)

puts "Minimal signal delay: ", distance
