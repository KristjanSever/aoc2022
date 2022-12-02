input = File.open("input.txt").readlines

sums = []
temp_sum = 0
input.each do |line|
  if line == "\n"
    sums << temp_sum
    temp_sum = 0
  end
  temp_sum += line.strip.to_i
end
sums.sort!
puts("task 1: #{sums[-1]}")
puts("task 2: #{sums[-3..].sum}")
