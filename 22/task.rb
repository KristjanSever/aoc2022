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
  if dir.x == 0 # moving up or down
    i = amount
    while i > 0
      if map[(pos.y + dir.y) % map.size][pos.x].nil? || map[(pos.y + dir.y) % map.size][pos.x] == "O" # wrapped around, try to go on next block
        tmp_y = (pos.y + dir.y) % map.size
        while map[tmp_y][pos.x].nil? || map[tmp_y][pos.x] == "O"
          tmp_y = (tmp_y + dir.y) % map.size
        end
        if map[tmp_y][pos.x] == "#"
          break # wall on the other side
        end
        pos.y = tmp_y
        i -= 1
        break if i.zero?
      end
      if map[(pos.y + dir.y) % map.size][pos.x] == "."
        pos.y = (pos.y + dir.y) % map.size
      end
      i -= 1
    end
  else # moving left or right
    i = amount
    while i > 0
      if map[pos.y][(pos.x + dir.x) % map[pos.y].size] == "O"
        tmp_x = (pos.x + dir.x) % map[pos.y].size
        while map[pos.y][tmp_x] == "O"
          tmp_x = (tmp_x + dir.x) % map[pos.y].size
        end
        if map[pos.y][tmp_x] == "#"
          break # wall on the other side
        end
        pos.x = tmp_x
        i -= 1
        break if i.zero?
      end
      if map[pos.y][(pos.x + dir.x) % map[pos.y].size] == "."
        pos.x = (pos.x + dir.x) % map[pos.y].size
      end
      i += 1 if map[pos.y][pos.x] == "O"
      i -= 1
    end
  end
end

def print_map_and_player(pos, map)
  tmp_map = Marshal.load(Marshal.dump(map.reverse))
  tmp_map[tmp_map.size - 1 - pos.y][pos.x] = "X"
  tmp_map.each do |row|
    puts row.join("")
  end
  nil
end

def teleport(pos, dir, map)
  if pos.x == 49 && pos.y.between?(0, 50) && dir.x == 1
    dir.y = 1
    dir.x = 0
    pos.x = 50 + (49 - pos.y)
    pos.y = 50
    return true
  end
  if pos.y == 50 && pos.x.between?(50, 100) && dir.y == -1
    dir.y = 0
    dir.x = -1
    pos.y = 99 - pos.x
    pos.x = 49
    return true
  end

  if pos.y == 99 && pos.x.between?(0, 49) && dir.y == 1
    dir.y = 0
    dir.x = 1
    pos.y = 100 + (49 - pos.x)
    pos.x = 50
    return true
  end
  if pos.x == 50 && pos.y.between?(100, 149) && dir.x == -1
    dir.y = -1
    dir.x = 0
    pos.x = 149 - pos.y
    pos.y = 49
    return true
  end

  if pos.y == 150 && pos.x.between?(100, 149) && dir.y == -1
    dir.y = 0
    dir.x = -1
    pos.y = 100 + (149 - pos.x)
    pos.x = 99
    return true
  end
  if pos.x == 99 && pos.y.between?(100, 149) && dir.x == 1
    dir.y = 1
    dir.x = 0
    pos.x = 149 + (100 - pos.y)
    pos.y = 150
    return true
  end

  if pos.x == 50 && pos.y.between?(150, 199) && dir.x == -1
    dir.y = 0
    dir.x = 1
    pos.y = 99 - (pos.y - 150)
    pos.x = 0
    return true
  end
  if pos.x == 0 && pos.y.between?(50, 99) && dir.x == -1
    dir.y = 0
    dir.x = 1
    pos.y = 249 - pos.y
    pos.x = 50
    return true
  end

  if pos.y == 199 && pos.x.between?(50, 99) && dir.y == 1
    dir.y = 0
    dir.x = 1
    pos.y = pos.x - 50
    pos.x = 0
    return true
  end
  if pos.x == 0 && pos.y.between?(0, 49) && dir.x == -1
    dir.y = -1
    dir.x = 0
    pos.x = pos.y + 50
    pos.y = 199
    return true
  end

  if pos.x == 149 && pos.y.between?(150, 199) && dir.x == 1
    dir.y = 0
    dir.x = -1
    pos.y = 249 - pos.y
    pos.x = 99
    return true
  end
  if pos.x == 99 && pos.y.between?(50, 99) && dir.x == 1
    dir.y = 0
    dir.x = -1
    pos.y = 249 - pos.y
    pos.x = 149
    return true
  end

  if pos.y == 0 && pos.x.between?(0, 49) && dir.y == -1
    dir.y = 0
    dir.x = -1
    pos.x = pos.x + 100
    pos.y = 199
    return true
  end
  if pos.y == 199 && pos.x.between?(100, 149) && dir.y == 1
    dir.y = 0
    dir.x = -1
    pos.x = pos.x - 100
    pos.y = 199
    return true
  end
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
  # binding.irb if instruction == "14"
  if instruction.to_i == 0 # rotation
    rotate(dir, instruction)
  else
    move_on_map(pos, dir, instruction.to_i, map)
    puts "#{pos.x}, #{pos.y}"
    puts "#{dir.x}, #{dir.y}"
    # print_map_and_player(pos, map)
    binding.irb
  end
end

puts(1000 * (map.size - pos.y) + 4 * (pos.x + 1) + facing(dir))
binding.irb