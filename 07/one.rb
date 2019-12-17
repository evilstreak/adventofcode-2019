require_relative 'intcode'

intcode_sequence = $stdin.read
phase_settings = [0, 1, 2, 3, 4]

configurations = phase_settings.permutation(5).map { |p|
  signal = p.reduce(0) { |input_value, phase_setting|
    inputs = [phase_setting, input_value]
    intcode = intcode_sequence.split(/,/).map(&:to_i)

    computer = IntcodeComputer.new(intcode)

    computer.run

    computer.provide_input(phase_setting)
    computer.provide_input(input_value)

    computer.get_output
  }

  [p, signal]
}

max = configurations.max_by(&:last)

puts "Highest thruster signal: #{max.last} (via #{max.first.join})"
