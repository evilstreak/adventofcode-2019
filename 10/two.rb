require_relative 'asteroid'

input = $stdin.read
map = Map.new(input)
best_site = map.best_monitoring_position
station = MonitoringStation.new(map, best_site)

first_sweep = station.sweep_laser
  
first_sweep.each do |a|
  puts "#{a.angle_from(best_site) * 180/Math::PI}: #{a.x}, #{a.y})"
end

a = first_sweep[199]
puts "200th asteroid vapourised: (#{a.x}, #{a.y})", "Answer: #{a.x * 100 + a.y}"

