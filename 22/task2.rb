map = []
reading_map = true
instruction_string = nil
while (l = gets)
  reading_map = false if l.strip == ""
  if reading_map
    map.append(l.delete("\n").gsub(" ", "O").split(""))
  else
    instruction_string = l.delete("\n")
  end
end
map = map.reverse
regex = /(\d+|L|R)/
instructions = instruction_string.scan(regex).flatten
Pos = Struct.new(:x, :y)
pos = Pos.new(0, map.size - 1)
dir = Pos.new(1, 0)
while map[pos.y][pos.x] != "."
  pos.x += dir.x
end

def rotate(dir, rotation)
  if dir.x == 0 && dir.y == 1 # moving up
    if rotation == "L"
      dir.x = -1
    else
      dir.x = 1
    end
    dir.y = 0
  elsif dir.x == 0 && dir.y == -1 # moving down
    if rotation == "L"
      dir.x = 1
    else
      dir.x = -1
    end
    dir.y = 0
  elsif dir.x == 1 && dir.y == 0 # moving right
    if rotation == "L"
      dir.y = 1
    else
      dir.y = -1
    end
    dir.x = 0
  else # moving left
    if rotation == "L"
      dir.y = -1
    else
      dir.y = 1
    end
    dir.x = 0
  end
end

def move_on_map(pos, dir, amount, map)
  i = amount
  while i > 0
    case teleport(pos, dir, map)
    when nil
      if map[pos.y + dir.y][pos.x + dir.x] == "#"
        break
      end
      pos.x += dir.x
      pos.y += dir.y
    when false
      break
    end
    i -= 1
  end
end

def teleport(pos, dir, map)
  orig_pos = pos.clone
  orig_dir = dir.clone
  did_move = nil
  # binding.irb
  if pos.x == 49 && pos.y.between?(0, 49) && dir.x == 1
    dir.y = 1
    dir.x = 0
    pos.x = 50 + (49 - pos.y)
    pos.y = 50
    did_move = map[pos.y][pos.x] == "."
  elsif pos.y == 50 && pos.x.between?(50, 99) && dir.y == -1
    dir.y = 0
    dir.x = -1
    pos.y = 99 - pos.x
    pos.x = 49
    did_move = map[pos.y][pos.x] == "."
  elsif pos.y == 99 && pos.x.between?(0, 49) && dir.y == 1
    dir.y = 0
    dir.x = 1
    pos.y = 100 + (49 - pos.x)
    pos.x = 50
    did_move = map[pos.y][pos.x] == "."
  elsif pos.x == 50 && pos.y.between?(100, 149) && dir.x == -1
    dir.y = -1
    dir.x = 0
    # Asdasd
    pos.x = 149 - pos.y
    pos.y = 99
    did_move = map[pos.y][pos.x] == "."
  elsif pos.y == 150 && pos.x.between?(100, 149) && dir.y == -1
    dir.y = 0
    dir.x = -1
    pos.y = 100 + (149 - pos.x)
    pos.x = 99
    did_move = map[pos.y][pos.x] == "."
  elsif pos.x == 99 && pos.y.between?(100, 149) && dir.x == 1
    dir.y = 1
    dir.x = 0
    pos.x = 149 + (100 - pos.y)
    pos.y = 150
    did_move = map[pos.y][pos.x] == "."
  elsif pos.x == 50 && pos.y.between?(150, 199) && dir.x == -1
    dir.y = 0
    dir.x = 1
    pos.y = 99 - (pos.y - 150)
    pos.x = 0
    did_move = map[pos.y][pos.x] == "."
  elsif pos.x == 0 && pos.y.between?(50, 99) && dir.x == -1
    dir.y = 0
    dir.x = 1
    pos.y = 249 - pos.y
    pos.x = 50
    did_move = map[pos.y][pos.x] == "."
  elsif pos.y == 199 && pos.x.between?(50, 99) && dir.y == 1
    dir.y = 0
    dir.x = 1
    pos.y = 99 - pos.x
    pos.x = 0
    did_move = map[pos.y][pos.x] == "."
  elsif pos.x == 0 && pos.y.between?(0, 49) && dir.x == -1
    dir.y = -1
    dir.x = 0
    pos.x = 99 - pos.y
    pos.y = 199
    did_move = map[pos.y][pos.x] == "."
  elsif pos.x == 149 && pos.y.between?(150, 199) && dir.x == 1
    dir.y = 0
    dir.x = -1
    # 199 -> 50
    # 150 -> 99
    pos.y = 50 + (199 - pos.y)
    pos.x = 99
    did_move = map[pos.y][pos.x] == "."
  elsif pos.x == 99 && pos.y.between?(50, 99) && dir.x == 1
    dir.y = 0
    dir.x = -1
    pos.y = 249 - pos.y
    pos.x = 149
    did_move = map[pos.y][pos.x] == "."
  elsif pos.y == 0 && pos.x.between?(0, 49) && dir.y == -1
    dir.y = -1
    dir.x = 0
    pos.x = pos.x + 100
    pos.y = 199
    did_move = map[pos.y][pos.x] == "."
  elsif pos.y == 199 && pos.x.between?(100, 149) && dir.y == 1
    dir.y = 1
    dir.x = 0
    pos.x = pos.x - 100
    pos.y = 0
    did_move = map[pos.y][pos.x] == "."
  end

  if did_move == false
    pos.x = orig_pos.x
    pos.y = orig_pos.y
    dir.x = orig_dir.x
    dir.y = orig_dir.y
  end
  did_move
end

def facing(dir)
  if dir.x == 0 && dir.y == 1 # moving up
    3
  elsif dir.x == 0 && dir.y == -1 # moving down
    1
  elsif dir.x == 1 && dir.y == 0 # moving right
    0
  else # moving left
    2
  end
end

instructions.each do |instruction|
  puts instruction
  if instruction.to_i == 0 # rotation
    rotate(dir, instruction)
  else
    move_on_map(pos, dir, instruction.to_i, map)
    puts "#{pos.x}, #{pos.y}"
    puts "#{dir.x}, #{dir.y}"
  end
end

puts(1000 * (map.size - pos.y) + 4 * (pos.x + 1) + facing(dir))
