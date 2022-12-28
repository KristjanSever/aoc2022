monkeys = {}
Monkey = Struct.new(:name, :number, :m1, :operator, :m2)
while (l = gets)
  data = l.strip.split(" ")
  if data.size == 2
    monkeys[data[0].delete(":")] = Monkey.new(data[0].delete(":"), data[1].to_i)
  else
    monkeys[data[0].delete(":")] = Monkey.new(data[0].delete(":"), nil, data[1], data[2], data[3])
  end
end


def eval_monkey(monkey, monkeys, memo)
  return memo[monkey.name] if memo[monkey.name]
  return monkey.number if monkey.number

  res = case monkey.operator
        when "*"
          eval_monkey(monkeys[monkey.m1], monkeys, memo) * eval_monkey(monkeys[monkey.m2], monkeys, memo)
        when "+"
          eval_monkey(monkeys[monkey.m1], monkeys, memo) + eval_monkey(monkeys[monkey.m2], monkeys, memo)
        when "/"
          eval_monkey(monkeys[monkey.m1], monkeys, memo) / eval_monkey(monkeys[monkey.m2], monkeys, memo).to_f
        when "-"
          eval_monkey(monkeys[monkey.m1], monkeys, memo) - eval_monkey(monkeys[monkey.m2], monkeys, memo)
        end
  memo[monkey.name] = res
  res
end
memo = {}
puts eval_monkey(monkeys["root"], monkeys, memo)
