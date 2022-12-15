regex = /Sensor at x=(?<x>-?\d*), y=(?<y>-?\d*): closest beacon is at x=(?<x_beacon>-?\d*), y=(?<y_beacon>-?\d*)\n?/

Point = Struct.new(:x, :y)
Pair = Struct.new(:sensor, :beacon, :man_dist)

def man_distance(x1, x2, y1, y2)
  (x2 - x1).abs + (y2 - y1).abs
end

def check_array(array)
  # array is sorted already by starting positions
  return nil if array.empty?
  start = array.first[:s]
  finish = array.first[:f]
  (1..array.size - 1).each do |i|
    pair = array[i]
    tmp_start = pair[:s]
    tmp_finish = pair[:f]
    # check start
    start = tmp_start if tmp_start < start
    # check finish
    finish = tmp_finish if tmp_finish > finish if tmp_start <= finish

    return tmp_start - 1 if tmp_start - 2 == finish
  end
  nil
end

def beacon_isnt_here(pair, target_row, row_array, min, max)
  x = pair.sensor.x
  y = pair.sensor.y
  dist = pair.man_dist

  change = dist - (target_row - y).abs
  start = x - change
  finish = x + change

  row_array.append({s: start, f: finish})
end

pairs = []
while (l = gets)
  m = l.match(regex)
  sensor = Point.new(m["x"].to_i, m["y"].to_i)
  beacon = Point.new(m["x_beacon"].to_i, m["y_beacon"].to_i)
  pairs.append(Pair.new(sensor, beacon, man_distance(sensor.x, beacon.x, sensor.y, beacon.y)))
end

worst = 4000000
(0..worst).each do |target_row|
  filtered_pairs = pairs.select do |pair|
    (pair.sensor.y - target_row).abs <= pair.man_dist
  end

  # sort by starts so its easier to check later
  filtered_pairs.sort! do |a, b| # a.length <=> b.length
    a_change = a.man_dist - (target_row - a.sensor.y).abs
    a_x = a.sensor.x

    b_change = b.man_dist - (target_row - b.sensor.y).abs
    b_x = b.sensor.x

    a_x - a_change <=> b_x - b_change
  end

  # calculate the size of the row in x dir
  min = Float::INFINITY
  max = -Float::INFINITY

  filtered_pairs.each do |pair|
    min = pair.sensor.x - pair.man_dist if pair.sensor.x - pair.man_dist < min
    max = pair.sensor.x + pair.man_dist if pair.sensor.x + pair.man_dist > max
  end

  row_array = []
  filtered_pairs.each do |pair|
    # row_array[pair.sensor.x - min] = "S" if pair.sensor.y == target_row
    # row_array[pair.beacon.x - min] = "B" if pair.beacon.y == target_row
    beacon_isnt_here(pair, target_row, row_array, min, max)
  end
  res = check_array(row_array)
  if !res.nil?
    puts res * worst + target_row
    break
  end

  # binding.irb if row_array.join("").gsub(/\A[.]+|[.]+\Z/,'').count(".") > 0
end

puts row_array.count("#")