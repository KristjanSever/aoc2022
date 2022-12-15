input = File.open("input.txt").readlines

class Point
  attr_accessor :x, :y

  def initialize(*args)
    if args.size == 1
      @x = args[0].x
      @y = args[0].y
    else
      @x = args[0]
      @y = args[1]
    end
  end

  def to_s
    "#{x},#{y}"
  end
end

def nothing_below?(point, map)
  return true if map[point.x].empty?
  point.y > map[point.x].keys.sort.last
end

def empty_below?(point, map)
  map[point.x][point.y + 1].nil?
end

def empty_down_left?(point, map)
  map[point.x - 1] ||= {}
  map[point.x - 1][point.y + 1].nil?
end

def empty_down_right?(point, map)
  map[point.x + 1] ||= {}
  map[point.x + 1][point.y + 1].nil?
end

map = {}
map_arr = []

sand_start = Point.new(500, 0)
map[sand_start.x] = { 0 => "+" }
input.each do |line|
  points = line.strip.split(" -> ")
  points = points.map do |p| 
    x, y = p.split(",")
    Point.new(x, y)
  end

  (0..points.size - 1).each do |i|
    next if i.zero?

    if points[i].x == points[i - 1].x
      if points[i].y > points[i - 1].y
        map[points[i].x.to_i] ||= {}
        (points[i - 1].y..points[i].y).each do |sand_index|
          map[points[i].x.to_i][sand_index.to_i] = "#"

        end
      else
        map[points[i].x.to_i] ||= {}
        (points[i].y..points[i - 1].y).each do |sand_index|
          map[points[i].x.to_i][sand_index.to_i] = "#"

        end
      end
    else
      if points[i].x > points[i - 1].x
        (points[i - 1].x..points[i].x).each do |sand_index|
          map[sand_index.to_i] ||= {}
          map[sand_index.to_i][points[i].y.to_i] = "#"

        end
      else
        (points[i].x..points[i - 1].x).each do |sand_index|
          map[sand_index.to_i] ||= {}
          map[sand_index.to_i][points[i].y.to_i] = "#"

        end
      end
    end
  end
end

num_sand = 0
filling = true
while filling
  cur_sand = Point.new(sand_start)
  loop do
    if nothing_below?(cur_sand, map)
      # over
      filling = false
      break
    end
    if empty_below?(cur_sand, map)
      cur_sand.y += 1 
    elsif empty_down_left?(cur_sand, map)
      cur_sand.x -= 1 
      cur_sand.y += 1 
    elsif empty_down_right?(cur_sand, map)
      cur_sand.x += 1 
      cur_sand.y += 1 
    else
      # cant move sand anymore
      map[cur_sand.x][cur_sand.y] = "o"
      num_sand += 1
      break
    end
  end
end
puts("task 1: #{num_sand}")
