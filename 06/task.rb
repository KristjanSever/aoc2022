require 'set'
input = File.open("input.txt").read

PACKET_LENGTH_TASK_1 = 4
PACKET_LENGTH_TASK_2 = 14

buffer_task1 = []
buffer_task2 = []
res_task1 = nil
res_task2 = nil
input.each_char.with_index do |char, index|
  # task 1
  buffer_task1.append(char)
  buffer_task1.shift if buffer_task1.size > PACKET_LENGTH_TASK_1
  if res_task1.nil? && buffer_task1.size == PACKET_LENGTH_TASK_1 && buffer_task1.uniq.size == PACKET_LENGTH_TASK_1
    res_task1 = index
  end
  # task 2
  buffer_task2.append(char)
  buffer_task2.shift if buffer_task2.size > PACKET_LENGTH_TASK_2
  if res_task2.nil? && buffer_task2.size == PACKET_LENGTH_TASK_2 && buffer_task2.uniq.size == PACKET_LENGTH_TASK_2
    res_task2 = index
  end
  next if res_task1.nil? || res_task2.nil?
end
# add 1 to result because indexes start at 0
puts res_task1 + 1 
puts res_task2 + 1
