require 'set'
regex = /Valve (?<name>.*) has flow rate=(?<flow_rate>\d*); tunnels? leads? to valves? (?<nodes>.*)\n?/
# Valve AA has flow rate=0; tunnels lead to valves DD, II, BB

class Node
  attr_accessor :neighbours, :name, :flow_rate, :important_neighbours
  def initialize(name, flow_rate, valves)
    @name = name
    @flow_rate = flow_rate.to_i
    @neighbours = valves.split(", ")
    @important_neighbours = {}
  end
end

graph = {}
while (l = gets)
  m = l.match(regex)
  graph[m["name"]] = Node.new(m["name"], m["flow_rate"], m["nodes"])
end

$cache = {}

start = graph["AA"]
# important is just nodes which have flow
important = graph.reject { |_, e| e.flow_rate.zero? }
important["AA"] = start # add first node as well because its where we start

def bfs(start, graph, important)
  queue = [[start.name, 0]]
  visited = Set.new
  visited.add(start.name)

  until queue.empty?
    name, weight = queue.shift

    if important[name] && name != start.name

      important[start.name].important_neighbours[name] = weight
    end

    neighbours = graph[name].neighbours

    neighbours.each do |neighbor|
      # If the neighbor has not been visited, add it to the queue and mark it as visited
      unless visited.include?(neighbor)
        queue << [neighbor, weight + 1]
        visited.add(neighbor)
      end
    end
  end
end

# create a graph with important nodes
important.each do |_, v|
  bfs(v, graph, important)
end

# only those with flow > 0 can be opened
valves_to_open = important.select { |_, v| v.flow_rate > 0 }.keys

queue = [{ name: start.name, opened: [], cur_released: 0, remaining_minutes: 26 }]

visited = {}

while queue.any?
  elem = queue.shift

  # basically a set operation, checks which nodes were not opened yet
  (valves_to_open - elem[:opened]).each do |next_node|
    weight = important[elem[:name]].important_neighbours[next_node]

    remaining_minutes = elem[:remaining_minutes] - weight - 1
    next if remaining_minutes < 0

    next_pressure = elem[:cur_released] + important[next_node].flow_rate * remaining_minutes
    opened_valves = elem[:opened].clone.append(next_node)

    key = "#{next_node}::#{opened_valves.join(",")}"
    next if visited[key] && visited[key] > next_pressure

    visited[key] = next_pressure
    queue.append({ name: next_node, opened: opened_valves, cur_released: next_pressure, remaining_minutes: remaining_minutes})
  end
end

uniq = {}
# get biggest possible score per opened valves at the end
visited.each do |k, v|
  opened = k.split("::")[1].split(",").sort
  next if uniq[opened] && v < uniq[opened]

  uniq[opened] = v
end

# now we have all biggest scores per unique opened_valves |score, set_opened_valves|
# we can now parse them two times, basically checking just options that dont overlap (empty union)
# overlapping would mean you and the elephant both opened and scored on the same valve, which is not okay
max = 0
uniq.each do |you_opened, cur_released|
  uniq.each do |sloncek_opened, sloncek_released|
    if you_opened & sloncek_opened  == []
      tmp = cur_released + sloncek_released

      max = tmp if tmp > max
    end
  end
end

puts max
