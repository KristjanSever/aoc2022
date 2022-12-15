regex = /Sensor at x=(?<x>-?\d*), y=(?<y>-?\d*): closest beacon is at x=(?<x_beacon>-?\d*), y=(?<y_beacon>-?\d*)\n?/

Point = Struct.new(:x, :y)
Pair = Struct.new(:sensor, :beacon, :man_dist)

def man_distance(x1, x2, y1, y2)
  (x2 - x1).abs + (y2 - y1).abs
end

def beacon_isnt_here(pair, target_row, row_array, min, max)
  x = pair.sensor.x
  y = pair.sensor.y
  dist = pair.man_dist

  change = dist - (target_row - y).abs
  (x - change..x + change).each do |i|
    next if x < min || x >= max
    row_array[i - min] = "#" if row_array[i - min] == "."
  end
end

pairs = []
while (l = gets)
  m = l.match(regex)
  sensor = Point.new(m["x"].to_i, m["y"].to_i)
  beacon = Point.new(m["x_beacon"].to_i, m["y_beacon"].to_i)
  pairs.append(Pair.new(sensor, beacon, man_distance(sensor.x, beacon.x, sensor.y, beacon.y)))
end

target_row = 2000000
filtered_pairs = pairs.select do |pair|
  (pair.sensor.y - target_row).abs <= pair.man_dist
end

# calculate the size of the row in x dir
min = Float::INFINITY
max = -Float::INFINITY
filtered_pairs.each do |pair|
  min = pair.sensor.x - pair.man_dist if pair.sensor.x - pair.man_dist < min
  max = pair.sensor.x + pair.man_dist if pair.sensor.x + pair.man_dist > max
end

row_array = Array.new(10_000_000, ".")
filtered_pairs.each do |pair|
  row_array[pair.sensor.x - min] = "S" if pair.sensor.y == target_row
  row_array[pair.beacon.x - min] = "B" if pair.beacon.y == target_row

  beacon_isnt_here(pair, target_row, row_array, min, max)
end

puts row_array.count("#")