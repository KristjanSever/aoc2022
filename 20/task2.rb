require_relative "linked_list.rb"
decription_key = 811589153
vals = []
index = 0
index_of_zero = nil
while (l = gets)
  vals.append([l.strip.to_i * decription_key, index])
  index += 1
end

vals = vals.map {|val, index| Node.new(val, index)}

vals.each.with_index do |el, i|
  index_of_zero = i if el.to_i == 0
  el.next = vals[(i + 1) % vals.size]
  el.prev = vals[(i - 1) % vals.size]
end

def mix(vals)
  vals.each do |node|
    node.move(node.to_i, vals.size)
  end
end
10.times do 
  mix(vals)
end

res = 0
cur = vals[index_of_zero]
3000.times do |i|
  cur = cur.next
  res += cur.to_i if ((i+1) % 1000).zero?
end

puts res
