def mapper(num)
  case num
  when 0
    [0, 0]
  when 1
    [0, 1]
  when 2
    [0, 2]
  when 3
    [1, "="]
  when 4
    [1, "-"]
  when 5
    [1, 0]
  end
end

def mapper_s(snafu)
  case snafu.to_s
  when "0"
    0
  when "1"
    1
  when "2"
    2
  when "="
    -2
  when "-"
    -1
  end
end

def dec_to_snafu(dec)
  reduced = ""
  carry = 0
  dec.to_s(5).reverse.each_char do |cur|
    carry, cur = mapper(cur.to_i + carry)
    reduced += cur.to_s
  end
  reduced += carry.to_s if carry.to_s != "0"
  reduced.reverse
end

def snafu_to_dec(snafu)
  res = 0
  pot = 1
  snafu.reverse.each_char do |c|
    res += pot * mapper_s(c)
    pot *= 5
  end
  res
end

sum = 0
while (l = gets)
  sum += snafu_to_dec(l.strip)
end
puts("task 1: #{dec_to_snafu(sum)}")