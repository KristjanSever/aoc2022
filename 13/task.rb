require 'json'
input = File.open("input.txt").readlines
slice_size = 3
def save(thing)
  Marshal.dump(thing)
end
def load(thing)
  Marshal.load(thing)
end

def compare(left, right)
  left = load(left)
  right = load(right)

  return left < right if left.is_a?(Integer) && right.is_a?(Integer) && left != right

  if left.is_a?(Array) && right.is_a?(Array)
    left.each.with_index do |l, i|
      return false if right[i].nil?

      res = compare(save(l), save(right[i]))
      return res unless res.nil?
    end
    return true if left.size < right.size
  end
  return compare(save([left]), save(right)) if left.is_a?(Integer) && right.is_a?(Array)

  return compare(save(left), save([right])) if right.is_a?(Integer) && left.is_a?(Array)
end

sum = 0
packets = []
input.each_slice(slice_size).with_index do |batch, i|
  first, second = batch.map(&:strip).reject(&:empty?).map { |el| JSON.parse(el) }
  packets.append(first)
  packets.append(second)
  correct = compare(Marshal.dump(first), Marshal.dump(second))
  sum += 1 + i if correct
end
puts("task 1: #{sum}")

divider1 = [[2]]
divider2 = [[6]]
packets.append(divider1)
packets.append(divider2)
packets.sort! do |left, right|
  compare(save(left), save(right)) ? -1 : 1
end

puts("task 2: #{(packets.index(divider1) + 1) * (packets.index(divider2) + 1)}")

