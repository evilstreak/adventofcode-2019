class UnknownOpcode < StandardError; end

class IntcodeComputer
  attr_reader :intcode, :index, :relative_base, :inputs, :outputs, :state

  PAUSED = :paused
  INITIALIZED = :initialized
  RUNNING = :running
  HALTED = :halted

  def initialize(intcode)
    @intcode = intcode
    @index = 0
    @relative_base = 0
    @inputs = []
    @outputs = []
    @state = INITIALIZED
  end

  def run
    @state = RUNNING
    step while state == RUNNING
  end

  def step
    case intcode[index] % 100
    when 1
      write(read(0) + read(1), 2)
      @index += 4
    when 2
      write(read(0) * read(1), 2)
      @index += 4
    when 3
      if inputs.empty?
        @state = PAUSED
      else
        write(get_input, 0)
        @index += 2
      end
    when 4
      store_output(read(0))
      @index += 2
    when 5
      read(0) != 0 ? @index = read(1) : @index += 3
    when 6
      read(0) == 0 ? @index = read(1) : @index += 3
    when 7
      write(read(0) < read(1) ? 1 : 0, 2)
      @index += 4
    when 8
      write(read(0) == read(1) ? 1 : 0, 2)
      @index += 4
    when 9
      @relative_base += read(0)
      @index += 2
    when 99
      @state = HALTED
    else
      raise UnknownOpcode.new("Unknown Opcode: #{intcode[index]} at index #{index}")
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

  def read(parameter_index)
    intcode[true_parameter_index(parameter_index)]
  end

  def write(value, parameter_index)
    intcode[true_parameter_index(parameter_index)] = value
  end

  def true_parameter_index(parameter_index)
    i = case parameter_mode(parameter_index)
    when 0
      intcode[index + parameter_index + 1]
    when 1
      index + parameter_index + 1
    when 2
      relative_base + intcode[index + parameter_index + 1]
    end

    if i > intcode.length
      l = intcode.length
      intcode[i] = 0
      intcode.fill(0, l)
    end

    i
  end

  def parameter_mode(parameter_index)
    intcode[index].digits.fetch(parameter_index + 2, 0)
  end
end
