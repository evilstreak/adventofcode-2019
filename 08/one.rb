input = $stdin.read.chars.map(&:to_i)

slices = input.each_slice(25*6)

fewest_zeroes = slices.min_by { |s| s.count(0) }

puts "Checksum: #{fewest_zeroes.count(1) * fewest_zeroes.count(2)}"
