input = File.open("input.txt").readlines

map = []

input.each do |line|
  line.strip!
  map.append(line.split("").map(&:to_i))
end

def visible_from(dir, row, column, map)
  # check left
  height = map[row][column]
  i = 1
  case dir
  when :left
    while column - i >= 0
      return false if map[row][column - i] >= height

      i += 1
    end
  when :right
    while column + i < map.first.size
      return false if map[row][column + i] >= height

      i += 1
    end
  when :up
    while row - i >= 0
      return false if map[row - i][column] >= height

      i += 1
    end
  when :down
    while row + i < map.size
      return false if map[row + i][column] >= height

      i += 1
    end
  end
  true
end

def tree_visible?(row, column, map)
  visible_from(:left, row, column, map) ||
    visible_from(:right, row, column, map) ||
    visible_from(:up, row, column, map) ||
    visible_from(:down, row, column, map)
end
visible_trees = 0
map.each_with_index do |_, row|
  map.first.each_with_index do |_, column|
    visible_trees += 1 if tree_visible?(row, column, map)
  end
end
puts visible_trees
