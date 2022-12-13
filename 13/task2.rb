require 'json'
input = File.open("input.txt").readlines
slice_size = 3
def save(thing)
  Marshal.dump(thing) # dangerous, but didnt know how else to deep copy
end
def load(thing)
  Marshal.load(thing)
end

def compare(left, right) # good luck trying to read this
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

divider1 = [[2]]
divider2 = [[6]]
packets = [divider1, divider2]
input.each_slice(slice_size) do |batch|
  first, second = batch.map(&:strip).reject(&:empty?).map { |el| JSON.parse(el) }
  packets.append(first)
  packets.append(second)
end

packets.sort! do |left, right|
  compare(save(left), save(right)) ? -1 : 1
end

puts (packets.index(divider1) + 1) * (packets.index(divider2) + 1)
