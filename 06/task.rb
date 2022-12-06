require 'set'
input = File.open("input.txt").read

buffer_task1 = []
buffer_task2 = []
res_task1 = -1
res_task2 = -1
input.each_char.with_index do |char, index|
  # task 1
  buffer_task1.append(char)
  buffer_task1.shift if buffer_task1.size > 4
  res_task1 = index + 1 if buffer_task1.size == 4 && res_task1.negative? && buffer_task1.size == buffer_task1.uniq.size
  # task 2
  buffer_task2.append(char)
  buffer_task2.shift if buffer_task2.size > 14
  res_task2 = index + 1 if buffer_task2.size == 14 && res_task2.negative? && buffer_task2.size == buffer_task2.uniq.size
  break if res_task1.positive? && res_task2.positive?
end
puts res_task1
puts res_task2
