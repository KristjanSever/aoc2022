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
  # add 0, 0, 0
  subtract = 0
  # check 6 sides around if any faces are there yet
  subtract += 2 if sides[:left][[x + 1, y, z]]
  subtract += 2 if sides[:right][[x - 1, y, z]]
  subtract += 2 if sides[:down][[x, y + 1, z]]
  subtract += 2 if sides[:up][[x, y - 1, z]]
  subtract += 2 if sides[:back][[x, y, z + 1]]
  subtract += 2 if sides[:front][[x, y, z - 1]]

  sides[:left][[x, y, z]] = true
  sides[:right][[x, y, z]] = true
  sides[:up][[x, y, z]] = true
  sides[:down][[x, y, z]] = true
  sides[:front][[x, y, z]] = true
  sides[:back][[x, y, z]] = true

  subtract
end
faces = 0
Cube = Struct.new(:x, :y, :z)
cubes = []
while (l = gets)
  x, y, z = l.strip.split(",").map(&:to_i)
  faces += 6 - add_side(x, y, z, sides)
end
puts("task 1: #{faces}")
binding.irb