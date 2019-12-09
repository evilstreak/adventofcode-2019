require_relative 'password'

from, to = $stdin.read.split(/-/)

from = from.to_i
to = to.to_i

valid_passwords = valid_passwords_in_range(from, to)

puts "Valid passwords in range #{from}-#{to}: ", valid_passwords
