require_relative 'intcode'

intcode = $stdin.read.split(/,/).map(&:to_i)

output = []

input = -> { 1 }
output_function = ->(value) {
  output << value
}

run_intcode(intcode, input, output_function)

puts "Output from intcode:", output.inspect
