input = $stdin.read.chars.map(&:to_i)

slices = input.each_slice(25*6)

render = slices.reduce { |front, back|
  front.map.with_index { |pixel, index|
    pixel == 2 ? back[index] : pixel
  }
}

render.map! { |pixel|
  pixel == 0 ? " " : "█"
}

puts "Message reads: ", render.each_slice(25).map(&:join).join("\n")
