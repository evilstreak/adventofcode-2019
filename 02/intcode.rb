class UnknownOpcode < StandardError; end

def run_intcode(data)
  index = 0

  loop do
    break unless run_opcode(data, index)
    index += 4
  end

  data
end

def run_opcode(data, index)
  opcode, r1, r2, write = data[index..index+3]

  case opcode
  when 1
    data[write] = data[r1] + data[r2]
  when 2
    data[write] = data[r1] * data[r2]
  when 99
    return false
  else
    raise UnknownOpcode.new
  end

  data
end
