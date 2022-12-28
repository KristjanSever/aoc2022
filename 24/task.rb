require "set"

map = []
while (l = gets)
  map.append(l.strip.split(""))
end

Point = Struct.new(:x, :y)

Wind = Struct.new(:x, :y, :dir_x, :dir_y)
winds = []
map.each.with_index do |row, y|
  row.each.with_index do |col, x|
    case col
    when ">"
      winds.append(Wind.new(x, y, 1, 0))
    when "<"
      winds.append(Wind.new(x, y, -1, 0))
    when "v"
      winds.append(Wind.new(x, y, 0, 1))
    when "^"
      winds.append(Wind.new(x, y, 0, -1))
    end
    map[y][x] = "." if map[y][x] != "#"
  end
end

def move_wind(wind, map)
  wind.y += wind.dir_y
  wind.x += wind.dir_x
  return if map[wind.y][wind.x] != "#" # wall not hit

  loop do # if wall hit move to the wall on the other side
    wind.y -= wind.dir_y
    wind.x -= wind.dir_x

    break if map[wind.y][wind.x] == "#" # stop if found
  end
  # move one space back into cave
  wind.x += wind.dir_x
  wind.y += wind.dir_y
end

def move_wind_minute(wind_orig, map, amount)
  wind = wind_orig.clone
  amount.times do
    wind.y += wind.dir_y
    wind.x += wind.dir_x
    next if map[wind.y][wind.x] != "#" # wall not hit

    loop do # if wall hit move to the wall on the other side
      wind.y -= wind.dir_y
      wind.x -= wind.dir_x

      break if map[wind.y][wind.x] == "#" # stop if found
    end
    # move one space back into cave
    wind.x += wind.dir_x
    wind.y += wind.dir_y
  end
  wind
end

def move_wind_minute_fast(wind_orig, map, amount)
  wind = wind_orig.clone
  wind.x = ((wind.x - 1 + amount * wind.dir_x) % (map.first.size - 2)) + 1
  wind.y = ((wind.y - 1 + amount * wind.dir_y) % (map.size - 2)) + 1
  wind
end

def neighbours(x, y, map, visited)
  res = []
  res.append([x - 1, y]) if map[y][x - 1] == "."
  res.append([x + 1, y]) if map[y][x + 1] == "."
  res.append([x, y - 1]) if map[y - 1][x] == "." if map[y - 1]
  res.append([x, y + 1]) if map[y + 1][x] == "." if map[y + 1]
  res.append([x, y])     if map[y][x] == "."
  res
end

def man_dist(x, y, finish)
  (x - finish.x).abs + (y - finish.y).abs
end

# binding.irb
def dijkstra(start, finish, minutes, winds, map)
  memo = {}
  visited = Set.new
  # state: pos, minutes_passed
  queue = [[start.x, start.y, minutes]]

  while queue.any?
    x, y, minutes = queue.shift

    cur_map = nil
    if memo[minutes]
      cur_map = memo[minutes]
    else
      cur_map = Marshal.load(Marshal.dump(map))
      cur_winds = winds.map { |w| move_wind_minute_fast(w, map, minutes) }
      cur_winds.each do |wind|
        cur_map[wind.y][wind.x] = "w"
      end
      memo[minutes] = cur_map
    end

    if x == finish.x && y == finish.y
      puts("#{minutes - 1}")
      return minutes - 1
    end
    # puts("#{minutes}, #{queue.size}, #{visited.size}") if visited.size % 1000 == 0

    n = neighbours(x, y, cur_map, visited)
    n = n.map { |el| [el[0], el[1], minutes + 1] }

    n.each do |e|
      queue.append(e) if visited.add?([e[0], e[1], e[2]])
    end

  end
end

# def dijkstra(start, finish, minutes, winds, map)
start = Point.new(map.first.find_index("."), 0)
finish = Point.new(map.last.find_index("."), map.size - 1)
min = dijkstra(start, finish, 1, winds, map)
min = dijkstra(finish, start, min, winds, map)
min = dijkstra(start, finish, min, winds, map)

puts min