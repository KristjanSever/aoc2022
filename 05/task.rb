require 'set'
input = File.open("input.txt").readlines

task1_stacks = {}
task2_stacks = {}

starting_position_instructions = true
input.each do |line|
  if line == "\n"
    task1_stacks.each_key do |k|
      task1_stacks[k].delete(" ")
    end
    task2_stacks = Marshal.load(Marshal.dump(task1_stacks))
    starting_position_instructions = false
    next
  end

  if starting_position_instructions 
    next unless line.include?("[")

    index = 1
    line.chars.each_slice(4) do |l|
      task1_stacks[index] ||= []
      task1_stacks[index].prepend(l[1])
      index += 1
    end
  else
    line = line.split(" ")
    num, from, to = line[1], line[3], line[5]

    task1_elems = task1_stacks[from.to_i].pop(num.to_i)
    task1_stacks[to.to_i].append(task1_elems.reverse).flatten!

    task2_elems = task2_stacks[from.to_i].pop(num.to_i)
    task2_stacks[to.to_i].append(task2_elems).flatten!

  end
end

puts task1_stacks.each.map { |_, stack| stack[-1] }.join
puts task2_stacks.each.map { |_, stack| stack[-1] }.join
