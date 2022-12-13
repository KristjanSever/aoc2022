require 'set'
input = File.open("input.txt").readlines

class Location
  attr_accessor :x, :y
  def initialize(x = 0, y = 0)
    @x = x
    @y = y
  end

  def to_s
    "#{x}:#{y}"
  end
end

def update_head_locaiton(head_location, direction)
  case direction
  when "R"
    head_location.x += 1
  when "L"
    head_location.x -= 1
  when "U"
    head_location.y -= 1
  when "D"
    head_location.y += 1
  end
end

def update_tail_locaiton(head_location, tail_location)
  diagonal = !((head_location.x == tail_location.x) || (head_location.y == tail_location.y))
  if (head_location.x - tail_location.x).abs > 1
    tail_location.x += (head_location.x - tail_location.x).positive? ? 1 : -1
    tail_location.y += (head_location.y - tail_location.y).positive? ? 1 : -1 if diagonal
  end

  return unless (head_location.y - tail_location.y).abs > 1

  tail_location.y += (head_location.y - tail_location.y).positive? ? 1 : -1
  tail_location.x += (head_location.x - tail_location.x).positive? ? 1 : -1 if diagonal
end

rope = []
10.times do
  rope.append(Location.new)
end
task1_locations = Set.new
task2_locations = Set.new
input.each do |line|
  direction, amount = line.strip.split(" ")
  amount.to_i.times do
    update_head_locaiton(rope.first, direction)
    (1..rope.size - 1).each do |i|
      update_tail_locaiton(rope[i - 1], rope[i])
    end
    task1_locations.add(rope[1].to_s)
    task2_locations.add(rope.last.to_s)
  end
end
puts("task 1 visited locations: #{task1_locations.size}")
puts("task 2 visited locations: #{task2_locations.size}")
