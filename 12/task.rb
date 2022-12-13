input = File.open("input.txt").readlines

class Node
  attr_accessor :x, :y, :height, :cur_min, :prev, :visited
  @@map = nil
  def initialize(x, y, height, cur_min, prev, visited = false)
    @x = x
    @y = y
    @height = height
    @cur_min = cur_min
    @prev = prev
    @visited = visited
  end

  def self.map(map)
    @@map = map
  end

  def visited?
    visited
  end

  def up
    return nil unless y - 1 >= 0

    @@map[y - 1][x]
  end

  def down
    return nil unless y + 1 < @@map.size

    @@map[y + 1][x]
  end

  def left
    return nil unless x - 1 >= 0

    @@map[y][x - 1]
  end

  def right
    return nil unless x + 1 < @@map.first.size

    @@map[y][x + 1]
  end

  def height_diff_ok(other_node)
    (other_node.height - height).between?(-Float::INFINITY, 1)
  end

  def to_s
    "#{x}, #{y}"
  end
end

@map = []
start_node = nil
end_node = nil
input.each.with_index do |cols, col_id|
  row_nodes = []
  cols.strip.split("").each.with_index do |row, row_id|
    if row == "S"
      start_node = Node.new(row_id, col_id, "a".ord, 0, nil)
      row_nodes.append(start_node)
      next
    end
    if row == "E"
      end_node = Node.new(row_id, col_id, "z".ord, Float::INFINITY, nil)
      row_nodes.append(end_node)
      next
    end
    row_nodes.append(Node.new(row_id, col_id, row.ord, Float::INFINITY, nil))
  end
  @map.append(row_nodes)
end

Node.map(@map)
queue = [start_node]
until queue.empty? do
  el = queue.shift
  break if el == end_node

  to_add = []
  to_add.append(el.down) if el.down && !el.down.visited? && el.height_diff_ok(el.down)
  to_add.append(el.right) if el.right && !el.right.visited? && el.height_diff_ok(el.right)
  to_add.append(el.up) if el.up && !el.up.visited? && el.height_diff_ok(el.up)
  to_add.append(el.left) if el.left && !el.left.visited? && el.height_diff_ok(el.left)

  to_add = to_add.compact.each do |node|
    if node.cur_min > el.cur_min + 1
      node.cur_min = el.cur_min + 1
      node.prev = el
    end
  end
  queue.append(to_add).flatten!

  el.visited = true
  queue.sort_by!(&:cur_min).uniq!
end

tmp = end_node
count = 0
until tmp.prev.nil?
  tmp = tmp.prev
  count += 1
end
puts count
