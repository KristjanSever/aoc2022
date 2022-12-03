require 'set'
input = File.open("input.txt").readlines

def find_common(lines)
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
input.each.each_slice(3) do |lines|
  stripped_lines = lines.map {|line| line.strip}
  score += priority(find_common(stripped_lines).first)
end

puts score
