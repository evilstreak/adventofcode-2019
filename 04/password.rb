class Password
  attr_reader :code

  def initialize(code)
    @code = code
  end

  def valid?
    !decreasing? && double?
  end

  def still_valid?
    !decreasing? && exact_double?
  end

  private

  def decreasing?
    # digits returns a bigendian array, so this might look backwards
    code.digits.each_cons(2).any? { |a, b| a < b }
  end

  def double?
    code.digits.group_by(&:itself).values.map(&:count).max >= 2
  end

  def exact_double?
    code.digits.group_by(&:itself).values.map(&:count).include?(2)
  end
end

def valid_passwords_in_range(from, to)
  (from...to).lazy.map { |code| Password.new(code) }.select(&:valid?).count
end

def still_valid_passwords_in_range(from, to)
  (from...to).lazy.map { |code| Password.new(code) }.select(&:still_valid?).count
end
