map = []
while (l = gets)
  map.append(l.strip.split(""))
end

directions = [:n, :s, :w, :e]

next_hash = {}
map.reverse.each.with_index do |row, y|
  row.each.with_index do |col, x|
    if col == "#"
      next_hash[[x, y]] = true
    end
  end
end

def alone?(coordinates, map)
  x, y = coordinates
  !(map[[x - 1, y + 1]] || map[[x, y + 1]] || map[[x + 1, y + 1]] ||
    map[[x - 1, y]]     ||                    map[[x + 1, y]] ||
    map[[x - 1, y - 1]] || map[[x, y - 1]] || map[[x + 1, y - 1]])
end

def proposed(coordinates, directions, map)
  x, y = coordinates
  directions.each do |dir|
    case dir
    when :n
      if !(map[[x - 1, y + 1]] || map[[x, y + 1]] || map[[x + 1, y + 1]] )
        return [x, y + 1]
      end
    when :s
      if !(map[[x - 1, y - 1]] || map[[x, y - 1]] || map[[x + 1, y - 1]])
        return [x, y - 1]
      end
    when :w
      if !(map[[x - 1, y + 1]] || map[[x - 1, y]] || map[[x - 1, y - 1]])
        return [x - 1, y]
      end
    when :e
      if !(map[[x + 1, y + 1]] ||  map[[x + 1, y]] ||  map[[x + 1, y - 1]])
        return [x + 1, y]
      end
    end
  end
end

def print_ar(map)
  res = Array.new(15) { Array.new(15, ".") }
  map.each do |coordinate, _|
    x, y = coordinate
    res[y][x] = "#"
  end
  res.reverse.each do |line|
    puts line.join
  end
  puts ""
end

def empty_tiles(map)
  vmin = map.keys.map { |e| e[0] }.min
  vmax = map.keys.map { |e| e[0] }.max
  hmin = map.keys.map { |e| e[1] }.min
  hmax = map.keys.map { |e| e[1] }.max

  (vmax - vmin + 1) * (hmax - hmin + 1) - map.size
end

10.times do
  map_hash = next_hash
  proposals = Hash.new(0)
  # we now have a map hash
  map_hash.each do |coordinates, _|
    if !alone?(coordinates, map_hash)
      proposed = proposed(coordinates, directions, map_hash)
      proposals[proposed] += 1
    end
  end

  next_hash = {}
  map_hash.each do |coordinates, _|
    new_loc = proposed(coordinates, directions, map_hash)
    if alone?(coordinates, map_hash) || proposals[new_loc] > 1
      next_hash[coordinates] = true
    else
      next_hash[new_loc] = true
    end
  end
  # print_ar(next_hash)
  directions.append(directions.shift)
end

puts empty_tiles(next_hash)
