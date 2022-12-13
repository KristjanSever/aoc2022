input = File.open("input.txt")

batch = 7
regex = %r{Monkey (?<monkey_num>\d*):
  Starting items: (?<items>.*)
  Operation: (?<operation>.*)
  Test: divisible by (?<divisor>\d*)
    If true: throw to monkey (?<true_monkey>\d*)
    If false: throw to monkey (?<false_monkey>\d*)\n?
} # couldnt get this to match the last \n?
regex = /Monkey (?<monkey_num>\d*):\n  Starting items: (?<items>.*)\n  Operation: (?<operation>.*)\n  Test: divisible by (?<divisor>\d*)\n    If true: throw to monkey (?<true_monkey>\d*)\n    If false: throw to monkey (?<false_monkey>\d*)\n?/


class Monkey
  attr_accessor :items, :inspections
  @@monkeys ||= {}

  def initialize(name, items, operation, divisor, condition_true, condition_false)
    @@monkeys[name.to_i] = self
    @items = items.split(",").map(&:to_i)
    @operation = operation.gsub("new", "neew")
    @divisor = divisor.to_i
    @condition_true = condition_true.to_i
    @condition_false = condition_false.to_i
    @inspections = 0
  end

  def list_monkeys
    @@monkeys
  end

  def self.lcm(num)
    @@lcm = num
  end
  
  def evaluate_operation
    old = @items[0]
    @items[0] = eval(@operation) % @@lcm
    @inspections += 1
  end

  def throw_item!
    item = @items.shift
    if (item % @divisor).zero?
      @@monkeys[@condition_true].items.append(item)
    else
      @@monkeys[@condition_false].items.append(item)
    end
  end

  def inspect_items
    items.size.times do 
      evaluate_operation
      throw_item!
    end
  end
end
# read input
monkeys = []
input.each_slice(batch) do |lines|
  rules = lines.join.match(regex)
  monkeys.append(Monkey.new(rules[:monkey_num], rules[:items], rules[:operation], rules[:divisor], rules[:true_monkey], rules[:false_monkey]))
end

rounds = 10000
lcm = monkeys.map {|monkey| monkey.items}.flatten.uniq.reduce(1) { |acc, n| acc.lcm(n) }
Monkey.lcm(lcm)
cur = 0
rounds.times.with_index do
  monkeys.each do |monkey|
    monkey.inspect_items
  end
end

monkeys = monkeys.sort_by(&:inspections).reverse
puts("task 2: #{monkeys[0].inspections * monkeys[1].inspections}")
