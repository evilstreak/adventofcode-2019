require_relative 'intcode'

intcode_sequence = $stdin.read
phase_settings = [5, 6, 7, 8, 9]

configurations = phase_settings.permutation(5).map { |p|
  amplifiers = p.map { |phase_setting|
    intcode = intcode_sequence.split(/,/).map(&:to_i)
    IntcodeComputer.new(intcode).tap { |computer|
      computer.provide_input(phase_setting)
      computer.run
    }
  }

  final_amplifier = amplifiers[4]
  thrust_signal = 0

  while final_amplifier.state != IntcodeComputer::HALTED
    thrust_signal = amplifiers.reduce(thrust_signal) { |input_value, amplifier|
      amplifier.provide_input(input_value)
      amplifier.get_output
    }
  end

  [p, thrust_signal]
}

max = configurations.max_by(&:last)

puts "Highest thruster signal: #{max.last} (via #{max.first.join})"
