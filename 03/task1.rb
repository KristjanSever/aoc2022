require 'set'
input = File.open("input.txt").readlines

def common(lines)
  lines.map(&:chars).inject { |common, cur| common & cur }
end

def priority(char)
  if char.downcase == char
    char.ord - "a".ord + 1
  else
    char.ord - "A".ord + 27
  end
end

score = 0
input.each do |line|
  line.strip!
  compartments = line.chars.each_slice(line.size / 2).map(&:join)
  score += priority(common(compartments).first)
end
puts score
