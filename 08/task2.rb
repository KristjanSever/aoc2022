input = File.open("input.txt").readlines

map = []

input.each do |line|
  line.strip!
  map.append(line.split("").map(&:to_i))
end

def num_of_visible_from(dir, row, column, map)
  # check left
  height = map[row][column]
  i = 0
  case dir
  when :left
    while (column - i).positive?
      i += 1
      return i if map[row][column - i] >= height
    end
  when :right
    while column + i < map.first.size - 1
      i += 1
      return i if map[row][column + i] >= height
    end
  when :up
    while (row - i).positive?
      i += 1
      return i if map[row - i][column] >= height
    end
  when :down
    while row + i < map.size - 1
      i += 1
      return i if map[row + i][column] >= height
    end
  end
  i
end

def num_of_tree_visible(row, column, map)
  num_of_visible_from(:left, row, column, map) *
    num_of_visible_from(:right, row, column, map) *
    num_of_visible_from(:up, row, column, map) *
    num_of_visible_from(:down, row, column, map)
end

semantic_score = 0
map.each_with_index do |_, row|
  map.first.each_with_index do |_, column|
    temp = num_of_tree_visible(row, column, map)
    semantic_score = temp if temp > semantic_score
  end
end
puts semantic_score
