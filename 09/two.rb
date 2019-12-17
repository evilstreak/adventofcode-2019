require_relative 'intcode'

intcode_sequence = $stdin.read.split(/,/).map(&:to_i)
computer = IntcodeComputer.new(intcode_sequence)

computer.provide_input(2)
computer.run

puts "Computer in state: #{computer.state}", "Output: #{computer.outputs.join(",")}"
