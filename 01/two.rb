require_relative 'fuel'

modules = $stdin.read.split(/\n/).map(&:to_i)
total_fuel = modules.map { |mass| net_fuel_required(mass) }.reduce(&:+)

puts "Total fuel required:", total_fuel
