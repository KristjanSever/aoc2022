# I will be abusing the "cyclic property of permutations" to get the desired outcome
# Example: Rock is 1, Paper is 2, Scissors are 3. If my opponent chooses Paper and I want
#          to win a match, i simply add +1 to my opponents choice. If i overflow the choices
#          (Scissors + 1 = 4), simply wrap around to 1. So if winning is +1, then losing is -1
#          and draws are +0.

# Code would be more readable if working with simple if else statemets
# for each outcome, but I like this solution so I will leave it

input = File.open("input.txt").readlines

@points = { "A": 1, "B": 2, "C": 3,
            "X": 1, "Y": 2, "Z": 3 }
ORD_DIF = "X".ord - "A".ord
task1_score = 0
task2_score = 0

def get_outcome_sym(opponent ,outcome)
  (65 + ((opponent.ord - 65) + outcome) % 3).chr.to_sym
end

def task1(opponent, you)
  score = @points[(opponent.ord + ORD_DIF).chr.to_sym]
  if (opponent.ord - (you.ord - ORD_DIF)).zero?
    score += 3
  elsif (opponent.ord - (you.ord - ORD_DIF)) % 3 == 2
    score += 6
  end
  score
end

def task2(opponent, outcome)
  score = 0
  case outcome
  when "X"
    score += @points[get_outcome_sym(opponent, -1)]
  when "Y"
    score += @points[opponent.to_sym]
    score += 3
  when "Z"
    score += @points[get_outcome_sym(opponent, 1)]
    score += 6
  end
  score
end

input.each do |line|
  line.strip!
  opponent, you = line.split(" ")

  task1_score += task1(opponent, you)
  outcome = you
  task2_score += task2(opponent, outcome)
end

puts("task 1: #{task1_score}")
puts("task 2: #{task2_score}")
