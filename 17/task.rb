require 'digest'
rocks =
  [
    [
      ["..@@@@."]
    ],
    [
      ["...@..."],
      ["..@@@.."],
      ["...@..."]
    ],
    [
      ["....@.."],
      ["....@.."],
      ["..@@@.."]
    ],
    [
      ["..@...."],
      ["..@...."],
      ["..@...."],
      ["..@...."]
    ],
    [
      ["..@@..."],
      ["..@@..."]
    ]
  ].freeze

def row_collision(rock_row, cave_row, debug=false)
  (0...cave_row.size).each do |i|
    next if cave_row[i] == "."

    return true if rock_row[0][i] == "@"
  end
  false
end

def collision?(rock, cave, debug=false)
  h = rock.h
  return true if h < 0

  rock.arr.reverse.each.with_index do |row, i|
    next if h + i >= cave.size
    return true if row_collision(row, cave[h + i], debug)
  end
  false
end

# moves rock if possible
def move_horizontally(dir, rock, cave)
  tmp_rock = rock.clone
  case dir
  when :l
    tmp_rock.arr = tmp_rock.arr.map do |row|
      str = row[0]
      str = str + "."
      [str[1..]]
    end
    rock.map
  when :r
    tmp_rock.arr = tmp_rock.arr.map { |row|
      str = row[0]
      str = "." + str
      [str[0..6]]
    }
  end

  return if collision?(tmp_rock, cave)
  return if tmp_rock.arr.flatten.join("").count("@") != rock.arr.flatten.join("").count("@")

  rock.arr = tmp_rock.arr
end

def burn_rock(rock, cave)
  h = rock.h
  rock.arr.reverse.each.with_index do |row, i|
    next if h + i >= cave.size

    row[0].each_char.with_index do |_, j|
      cave[h + i][j] = "#" if row[0][j] == "@"
    end
  end
end

def add_rock(cave, rock)
  Rock.new(cave.size - 1, rock)
end

def move_rock_down(rock)
  rock.h -= 1
end

def make_cave_higher(cave)
  while true
    break if cave[cave.size - 4..-1].flatten.count(".") == 28

    cave.append(Array.new(7, "."))
  end
end

def largest_repeating_pattern(str)
  # Initialize variables to track the largest repeating pattern and its length
  largest_pattern = ""
  largest_length = 0

  # Iterate through all substrings of the input string
  (0...str.length).each do |i|
    puts i
    (i+1...str.length).each do |j|
      # Get the current substring
      current_substring = str[i..j]

      # Check if the current substring is a repeating pattern in the input string
      if str.scan(current_substring).count > 1
        # If it is, update the largest repeating pattern and its length if necessary
        if current_substring.length > largest_length
          largest_pattern = current_substring
          largest_length = current_substring.length
        end
      end
    end
  end

  # Return the largest repeating pattern
  return largest_pattern
end

wind = File.open("input.txt").read.strip
Rock = Struct.new(:h, :arr)

cave =
[
  Array.new(7, "."),
  Array.new(7, "."),
  Array.new(7, "."),
  Array.new(7, ".")
]

rock_falling = false
rock = nil
rocks_fallen = 0
wind_num = 0
rock_num = 0

period = nil
repeating = false
rocks_in_period = 0
rock_key_period = nil
hits = {}
while true
  if !rock_falling
    rock = add_rock(cave, rocks[rock_num])
    rock_num = (rock_num + 1) % rocks.size
    rock_falling = true
    rocks_in_period += 1
  end

  dir = wind[wind_num] == "<" ? :l : :r
  wind_num = (wind_num + 1) % wind.size

  # move rock horizontally
  move_horizontally(dir, rock, cave)
  move_rock_down(rock)

  if collision?(rock, cave)
    rock.h += 1
    burn_rock(rock, cave)
    make_cave_higher(cave)
    binding.irb if rocks_in_period == 1600
    # if cave.size > 1000
    #   key = Digest::SHA256.digest(cave[-1000..].join)
    #   if repeating && rock_key_period == key
    #     binding.irb
    #   end
    #   if !repeating && !hits[key].nil?
    #     period = cave.size - hits[key]
    #     repeating = true
    #     rock_key_period = key
    #     binding.irb
    #   end
    #   hits[key] = cave.size
    # end
    rocks_fallen += 1
    rock_falling = false
  end

  puts rocks_fallen
  break if rocks_fallen >= 1000000000000
end
puts cave.size - 4


# remaining_rocks = 999999998400
# (remaining_rocks / 1725) * 2659 = 1541449272896
