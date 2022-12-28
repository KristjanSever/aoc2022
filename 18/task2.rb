# possible sides watching from the front
# each signifies coordinates of faces looking in that direction
# left right are x
# up down are y
# front back are z
sides =
{
  left: {},
  right: {},
  front: {},
  back: {},
  up: {},
  down: {}
}

def add_side(x, y, z, sides)
  # # add 0, 0, 0
  # subtract = 0
  # # check 6 sides around if any faces are there yet
  # subtract += 2 if sides[:left][[x + 1, y, z]]
  # subtract += 2 if sides[:right][[x - 1, y, z]]
  # subtract += 2 if sides[:down][[x, y + 1, z]]
  # subtract += 2 if sides[:up][[x, y - 1, z]]
  # subtract += 2 if sides[:back][[x, y, z + 1]]
  # subtract += 2 if sides[:front][[x, y, z - 1]]

  sides[:left][[x, y, z]] = true
  sides[:right][[x, y, z]] = true
  sides[:up][[x, y, z]] = true
  sides[:down][[x, y, z]] = true
  sides[:front][[x, y, z]] = true
  sides[:back][[x, y, z]] = true
end

def connected_to_outside(x, y, z, memo, space, max, visited)
  # return true if [x,y,z].min < 0 || [x,y,z].max >= max
  if x <= 0 || y <= 0 || z <= 0 ||
     x >= max || y >= max || z >= max
    return true
  end
  visited[[x,y,z]] = true

  return  memo[z][y][x] if memo[z][y][x]
  # puts "#{x}, #{y}, #{z}"

  is_connected = false
  if space[z][y][x + 1].zero? && visited[[x + 1, y, z]].nil?
    res = connected_to_outside(x + 1, y, z, memo, space, max, visited)
    memo[z][y][x + 1] = res
    return true if res
  end
  if space[z][y][x - 1].zero? && visited[[x - 1, y, z]].nil?
    res = connected_to_outside(x - 1, y, z, memo, space, max, visited)
    memo[z][y][x - 1] = res
    return true if res
  end
  if space[z][y + 1][x].zero? && visited[[x, y + 1, z]].nil?
    res = connected_to_outside(x, y + 1, z, memo, space, max, visited)
    memo[z][y + 1][x] = res
    return true if res
  end
  if space[z][y - 1][x].zero? && visited[[x, y - 1, z]].nil?
    res = connected_to_outside(x, y - 1, z, memo, space, max, visited)
    memo[z][y - 1][x] = res
    return true if res
  end
  if space[z + 1][y][x].zero? && visited[[x, y, z + 1]].nil?
    res = connected_to_outside(x, y, z + 1, memo, space, max, visited)
    memo[z + 1][y][x] = res
    return true if res
  end
  if space[z - 1][y][x].zero? && visited[[x, y, z - 1]].nil?
    res = connected_to_outside(x, y, z - 1, memo, space, max, visited)
    memo[z - 1][y][x] = res
    return true if res
  end

  # is_connected = connected_to_outside(x + 1, y, z, memo, space, max) if space[z][y][x + 1] == 0
  # is_connected = connected_to_outside(x - 1, y, z, memo, space, max) if space[z][y][x - 1] == 0 && !is_connected
  # is_connected = connected_to_outside(x, y + 1, z, memo, space, max) if space[z][y + 1][x] == 0 && !is_connected
  # is_connected = connected_to_outside(x, y - 1, z, memo, space, max) if space[z][y - 1][x] == 0 && !is_connected
  # is_connected = connected_to_outside(x, y, z + 1, memo, space, max) if space[z + 1][y][x] == 0 && !is_connected
  # is_connected = connected_to_outside(x, y, z - 1, memo, space, max) if space[z - 1][y][x] == 0 && !is_connected

  memo[z][y][x] = is_connected
  is_connected
end

def num(x, y, z, sides, memo, space, max, visited)
  faces = 0

  if !sides[:left][[x + 1, y, z]]
    res = connected_to_outside(x + 1, y, z, memo, space, max, {})
    faces += 1 if res
  end

  if !sides[:right][[x - 1, y, z]]
    res = connected_to_outside(x - 1, y, z, memo, space, max, {})
    faces += 1 if res
  end

  if !sides[:down][[x, y + 1, z]]
    res = connected_to_outside(x, y + 1, z, memo, space, max, {})
    faces += 1 if res
  end

  if !sides[:up][[x, y - 1, z]]
    res = connected_to_outside(x, y - 1, z, memo, space, max, {})
    faces += 1 if res
  end

  if !sides[:back][[x, y, z + 1]]
    res = connected_to_outside(x, y, z + 1, memo, space, max, {})
    faces += 1 if res
  end

  if !sides[:front][[x, y, z - 1]]
    res = connected_to_outside(x, y, z - 1, memo, space, max, {})
    faces += 1 if res
  end


  faces
end

min = Float::INFINITY
max = -Float::INFINITY
Cube = Struct.new(:x, :y, :z)
cubes = []
while (l = gets)
  x, y, z = l.strip.split(",").map(&:to_i)
  min = [min, x, y, z].min
  max = [max, x, y, z].max
  add_side(x, y, z, sides)
  cubes.append(Cube.new(x, y, z))
end

space = Array.new(max + 1) { Array.new(max + 1) { Array.new(max + 1, 0) } }
memo = Array.new(max + 1) { Array.new(max + 1) { Array.new(max + 1, nil) } }
visited = Array.new(max + 1) { Array.new(max + 1) { Array.new(max + 1, false) } }

cubes.each do |cube|
  # space[z][y][x]
  space[cube.z][cube.y][cube.x] = 1
end
faces = 0

cubes.sort! { |c1, c2| [c1.x, c1.y, c1.z] <=> [c2.x, c2.y, c2.z] }

cubes.each do |cube|
  # start

  faces += num(cube.x, cube.y, cube.z, sides, memo, space, max, visited)

end
binding.irb