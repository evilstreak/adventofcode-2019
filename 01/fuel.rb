def fuel_required(module_mass)
  module_mass / 3 - 2
end

def net_fuel_required(module_mass)
  fuel = fuel_required(module_mass)

  if fuel <= 0
    0
  else
    fuel + net_fuel_required(fuel)
  end
end
