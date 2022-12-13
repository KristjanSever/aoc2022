input = File.open("input.txt").readlines

register_x = 1
cycle = 0
cycles = [1,1,1]
input.each do |line|
  line.strip!
  instruction, value = line.split(" ")

  case instruction
  when "addx"
    cycle += 2
    register_x += value.to_i
    cycles[cycle] = register_x
    cycles[cycle + 1] = register_x
  when "noop"
    cycle += 1
    cycles[cycle + 1] = cycles[cycle]
  end
end

task1 = 20 * cycles[20] +
        60 * cycles[60] +
        100 * cycles[100] +
        140 * cycles[140] +
        180 * cycles[180] +
        220 * cycles[220]
puts("task 1: #{task1}")

columns = 40
str = ""
puts("task 2: read from output below")
cycles.each.with_index do |regx_val, index|
  if (index % columns).zero?
    puts str
    str = ""
  end
  pos = index % 40

  str += (regx_val..regx_val + 2).include?(pos + 1) ? "#" : "."
end

