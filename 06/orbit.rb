class SpaceObject
  attr_reader :name
  attr_accessor :parent

  def initialize(name, parent)
    @name = name
    @parent = parent
  end

  def orbits
    if parent.nil?
      puts name
    end

    parent.orbits + 1
  end

  def parents
    [parent] + parent.parents
  end

  def closest_shared_parent(other)
    parents.&(other.parents).first
  end

  def distance_from(other)
    closest_parent = closest_shared_parent(other)

    parents.index(closest_parent) + other.parents.index(closest_parent)
  end
end

class CenterOfMass
  def name
    "COM"
  end

  def orbits
    0
  end

  def parents
    []
  end
end

class OrbitMap
  attr_reader :objects

  def initialize(map_data)
    center_of_mass = CenterOfMass.new

    @objects = Hash.new { |hash, key|
      hash[key] = SpaceObject.new(key, nil)
    }

    @objects[center_of_mass.name] = center_of_mass

    map_data.each.with_object(@objects) { |orbital_relationship, objects|
      parent_name, child_name = orbital_relationship.split(")")

      parent = objects[parent_name]

      if objects.has_key?(child_name)
        objects.fetch(child_name).parent = parent
      else
        objects[child_name] = SpaceObject.new(child_name, parent)
      end
    }
  end

  def orbit_count_checksum
    objects.values.map(&:orbits).reduce(&:+)
  end
end
