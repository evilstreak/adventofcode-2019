require_relative 'asteroid'

input = $stdin.read
map = Map.new(input)
best_site = map.best_monitoring_position

puts "Best monitoring position: (#{best_site.x}, #{best_site.y})", "Asteroids visible: #{map.asteroids_detectable_from(best_site)}"
