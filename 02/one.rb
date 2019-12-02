require_relative 'intcode'

intcode = $stdin.read.split(/,/).map(&:to_i)

intcode[1] = 12
intcode[2] = 2

run_intcode(intcode)

puts "Value at index 0:", intcode[0]
