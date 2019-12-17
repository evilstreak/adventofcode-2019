class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def points_exactly_between(other)
    dx = other.x - x
    dy = other.y - y
    gcd = dx.gcd(dy)

    (1..(gcd - 1)).map { |n|
      Point.new(x + dx/gcd * n, y + dy/gcd * n)
    }
  end

  def ==(other)
    x == other.x && y == other.y
  end

  def angle_from(other)
    dx = x - other.x
    dy = y - other.y # ugh, reversed coordinate system

    (Math.atan2(dy, dx) - Math::PI / 2) % (Math::PI * 2)
    (Math.atan2(dy, dx) + Math::PI / 2) % (Math::PI * 2)
  end
end

class Map
  attr_reader :asteroids

  def initialize(data)
    @asteroids = data.split("\n").flat_map.with_index { |row, y|
      row.chars.map.with_index { |tile, x|
        Point.new(x, y) if tile == '#'
      }
    }.compact
  end

  def asteroids_detectable_from(point)
    asteroids.select { |rock|
      point != rock && !point.points_exactly_between(rock).any? { |p|
        asteroids.include?(p)
      }
    }
  end

  def best_monitoring_position
    asteroids.max_by { |a| asteroids_detectable_from(a).count }
  end
end

class MonitoringStation
  attr_reader :map, :point

  def initialize(map, point)
    @map = map
    @point = point
  end

  def sweep_laser
    targets = map.asteroids_detectable_from(point).sort_by { |a| a.angle_from(point) }

    map.asteroids.reject! { |a| targets.include?(a) }

    targets
  end
end
