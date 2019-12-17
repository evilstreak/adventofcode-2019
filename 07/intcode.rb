class UnknownOpcode < StandardError; end

def extract_parameter_modes(opcode_instruction, parameter_count)
  digits = opcode_instruction.digits.fill(
    0,
    opcode_instruction.digits.length,
    parameter_count + 1,
  )

  digits[2...2+parameter_count]
end

def extract_parameters(data, index, parameter_count)
  params = data[(index + 1)..(index + parameter_count)]
  parameter_modes = extract_parameter_modes(data[index], parameter_count)

  params.zip(parameter_modes).map { |value, mode|
  }
end

def addition_opcode(data, index, _input, _output)
  parameter_modes = extract_parameter_modes(data[index], 2)

  a, b, c = data[(index + 1)..(index + 4)]

  if parameter_modes[0] == 0
    a = data[a]
  end

  if parameter_modes[1] == 0
    b = data[b]
  end

  data[c] = a + b

  index + 4
end

def multiplication_opcode(data, index, _input, _output)
  parameter_modes = extract_parameter_modes(data[index], 2)

  a, b, c = data[(index + 1)..(index + 4)]

  if parameter_modes[0] == 0
    a = data[a]
  end

  if parameter_modes[1] == 0
    b = data[b]
  end

  data[c] = a * b

  index + 4
end

def halt_opcode(_data, _index, _input, _output)
  -1
end

def input_opcode(data, index, input, _output)
  target_index = data[index + 1]

  data[target_index] = input.call

  index + 2
end

def output_opcode(data, index, _input, output)
  parameter_modes = extract_parameter_modes(data[index], 1)
  value = data[index + 1]

  if parameter_modes[0] == 0
    value = data[value]
  end

  output.call(value)

  index + 2
end

def jump_if_true_opcode(data, index, _input, _output)
  parameter_modes = extract_parameter_modes(data[index], 2)
  condition, target = data[(index + 1)..(index + 3)]

  if parameter_modes[0] == 0
    condition = data[condition]
  end

  if parameter_modes[1] == 0
    target = data[target]
  end

  if condition != 0
    target
  else
    index + 3
  end
end

def jump_if_false_opcode(data, index, _input, _output)
  parameter_modes = extract_parameter_modes(data[index], 2)
  condition, target = data[(index + 1)..(index + 3)]

  if parameter_modes[0] == 0
    condition = data[condition]
  end

  if parameter_modes[1] == 0
    target = data[target]
  end

  if condition == 0
    target
  else
    index + 3
  end
end

def less_than_opcode(data, index, _input, _output)
  parameter_modes = extract_parameter_modes(data[index], 2)
  a, b, target = data[(index + 1)..(index + 4)]

  if parameter_modes[0] == 0
    a = data[a]
  end

  if parameter_modes[1] == 0
    b = data[b]
  end

  if a < b
    data[target] = 1
  else
    data[target] = 0
  end

  index + 4
end

def equals_opcode(data, index, _input, _output)
  parameter_modes = extract_parameter_modes(data[index], 2)
  a, b, target = data[(index + 1)..(index + 4)]

  if parameter_modes[0] == 0
    a = data[a]
  end

  if parameter_modes[1] == 0
    b = data[b]
  end

  if a == b
    data[target] = 1
  else
    data[target] = 0
  end

  index + 4
end

def lookup_opcode(opcode_instruction)
  case opcode_instruction % 100
  when 1
    method(:addition_opcode)
  when 2
    method(:multiplication_opcode)
  when 3
    method(:input_opcode)
  when 4
    method(:output_opcode)
  when 5
    method(:jump_if_true_opcode)
  when 6
    method(:jump_if_false_opcode)
  when 7
    method(:less_than_opcode)
  when 8
    method(:equals_opcode)
  when 99
    method(:halt_opcode)
  else
    raise UnknownOpcode.new("Unknown Opcode: #{opcode_instruction}")
  end
end

class IntcodeComputer
  attr_reader :intcode, :index, :inputs, :outputs, :state

  PAUSED = :paused
  INITIALIZED = :initialized
  RUNNING = :running
  HALTED = :halted

  def initialize(intcode)
    @intcode = intcode
    @index = 0
    @inputs = []
    @outputs = []
    @state = INITIALIZED
  end

  def run
    @state = RUNNING

    loop do
      opcode = lookup_opcode(intcode[index])

      if opcode == method(:input_opcode) && inputs.empty?
        @state = PAUSED
        break
      else
        @index = opcode.call(intcode, index, method(:get_input), method(:store_output))

        if index == -1
          @state = HALTED
          break
        end
      end
    end
  end

  def provide_input(value)
    inputs << value

    run if state == PAUSED
  end

  def get_output
    if outputs.empty?
      raise "empty outputs"
    else
      outputs.shift
    end
  end

  private

  def get_input
    if inputs.empty?
      raise "empty inputs"
    else
      inputs.shift
    end
  end

  def store_output(value)
    outputs << value
  end
end
