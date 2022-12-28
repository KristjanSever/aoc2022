monkeys = {}
Monkey = Struct.new(:name, :number, :m1, :operator, :m2)
Node = Struct.new(:num, :left, :right, :operator, :name)
while (l = gets)
  data = l.strip.split(" ")
  if data.size == 2
    monkeys[data[0].delete(":")] = Monkey.new(data[0].delete(":"), data[1].to_i)
  else
    monkeys[data[0].delete(":")] = Monkey.new(data[0].delete(":"), nil, data[1], data[2], data[3])
  end
end

def create_binary_tree(monkey, monkeys)
  return Node.new(monkey.number.to_f, nil, nil, nil, monkey.name) if monkey.number

  m1 = create_binary_tree(monkeys[monkey.m1], monkeys)
  m2 = create_binary_tree(monkeys[monkey.m2], monkeys)
  Node.new(nil, m1, m2, monkey.operator, monkey.name)
end

root = create_binary_tree(monkeys["root"], monkeys)

def evaluate_binary_tree(node, humn)
  return humn if node.name == "humn" && !humn.nil?
  return node.num if node.num

  node1 = evaluate_binary_tree(node.left, humn)
  node2 = evaluate_binary_tree(node.right, humn)
  case node.operator
  when "*"
    node1 * node2
  when "+"
    node1 + node2
  when "/"
    node1 / node2
  when "-"
    node1 - node2
  end
end

b = evaluate_binary_tree(root.right, "x")
def where_is_x(node)
  return true if node.num && node.num == "x"

  node1 = where_is_x(node.left) if node.left
  node2 = where_is_x(node.right) if node.right

  res = :left if node1
  res = :right if node2
  res
end

def reduce_to_x(node, cur_res)
  dir = where_is_x(node)
  while dir != nil
    num = if dir == :left
            evaluate_binary_tree(node.right) if node.right
          elsif node.left
            evaluate_binary_tree(node.left)
          end
    break if num.nil?
    case node.operator
    when "*"
      cur_res /= num
    when "+"
      cur_res -= num
    when "-"
      cur_res += num
    when "/"
      cur_res *= num
    end
    if dir == :left
      break if node.left.name == "humn"
      node = node.left
    else
      break if node.left.name == "humn"
      node = node.right
    end
    dir = where_is_x(node)
  end
  cur_res
end

# a = reduce_to_x(root.left, b)
rhs = evaluate_binary_tree(root.right, nil)
# 42130890593816.0

def binary_search(root, rhs)
  l = -10**20
  r = 10**20

  while l <= r
    c = (l + r) / 2
    t = evaluate_binary_tree(root, c)
    if t > rhs
      l = c
    elsif t < rhs
      r = c
    else
      #solution
      puts c
      break
    end

  end
  puts c
end

binary_search(root.left, rhs)
binding.irb