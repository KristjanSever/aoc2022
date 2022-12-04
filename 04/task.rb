require 'set'
input = File.open("input.txt").readlines

overlap_task1 = 0
overlap_task2 = 0
input.each do |line|
  line = line.strip.split(",")
  set1 = (line[0].split("-")[0].to_i..line[0].split("-")[1].to_i).to_set
  set2 = (line[1].split("-")[0].to_i..line[1].split("-")[1].to_i).to_set

  overlap_task1 += 1 if (set1 & set2).size == set1.size || (set1 & set2).size == set2.size
  overlap_task2 += 1 unless (set1 & set2).empty?
end

puts overlap_task1
puts overlap_task2
