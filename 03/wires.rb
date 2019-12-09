class Wire
  attr_reader :points

  def initialize(route)
    @points = route.reduce([Point::ORIGIN]) { |path, move|
      direction, *distance = move.chars
      distance = distance.join.to_i

      x = path.last.x
      y = path.last.y

      path + case direction
      when "U"
        distance.times.map { |dy|
          Point.new(x, y + dy + 1)
        }
      when "R"
        distance.times.map { |dx|
          Point.new(x + dx + 1, y)
        }
      when "D"
        distance.times.map { |dy|
          Point.new(x, y - dy - 1)
        }
      when "L"
        distance.times.map { |dx|
          Point.new(x - dx - 1, y)
        }
      else
        raise "Unknown direction"
      end
    }
  end

  def &(other)
    (points & other.points - [Point::ORIGIN]).sort_by(&:manhattan_distance)
  end
end

class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def manhattan_distance
    x.abs + y.abs
  end

  def ==(other)
    other.x == x && other.y == y
  end

  def eql?(other)
    self == other
  end

  def hash
    [x, y].hash
  end

  ORIGIN = self.new(0, 0)
end

def closest_crossing(wire1, wire2)
  points = Wire.new(wire1).&(Wire.new(wire2))
  points.first.manhattan_distance
end

def minimal_signal_delay(wire1, wire2)
  points = wire1 & wire2

  steps = points.map { |point|
    wire1.points.index(point) + wire2.points.index(point)
  }

  steps.min
end
