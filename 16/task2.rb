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
important = graph.reject { |_, e| e.flow_rate.zero?}
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


def params_to_s(cur_valve, minutes, cur_released, opened_valves)
  "#{cur_valve.name}::#{minutes}::#{opened_valves.join(",")}"
end

def find_most_pressure(cur_node, remaining_minutes, cur_released, opened_valves, graph, go_sloncek)
  cache_id = params_to_s(cur_node, remaining_minutes, cur_released, opened_valves)
  return $cache[cache_id] if $cache[cache_id]

  binding.irb if remaining_minutes.negative? # just checking, never stops here
  return cur_released if remaining_minutes <= 0

  max = -Float::INFINITY

  cur_node.important_neighbours.each do |next_node|
    next if next_node == "AA"

    weight = next_node[1]
    next_node = graph[next_node[0]]
    # open cur valve path if enough time and not opened yet
    if !opened_valves.include?(next_node.name) && remaining_minutes - weight - 1 >= 0

      val = cur_released + (remaining_minutes - weight - 1) * next_node.flow_rate
      opened = find_most_pressure(next_node,
                                  remaining_minutes - weight - 1,
                                  val,
                                  opened_valves.clone.append(next_node.name),
                                  graph,
                                  go_sloncek
                                 )

      # if go_sloncek
      #   slo = find_most_pressure(graph["AA"], 26, val, opened_valves.clone.append(next_node.name), graph, false)
      #   opened = slo if slo && slo > opened
      # end
    end

    # leave closed cur valve path
    if remaining_minutes - weight >= 0
      closed = find_most_pressure(next_node, remaining_minutes - weight, cur_released, opened_valves, graph, go_sloncek)
    end

    max = opened if opened && opened > max
    max = closed if closed && closed > max
  end

  cache_id = params_to_s(cur_node, remaining_minutes, cur_released, opened_valves)
  $cache[cache_id] = max
  max
end

# res = find_most_pressure(start, 30, 0, [], important, true)

valves_to_open = important.select { |k, v| v.flow_rate > 0 }.keys

queue = [{ name: start.name, opened: [], cur_released: 0, remaining_minutes: 26 }]
binding.irb
visited = {}

while queue.any?
  elem = queue.shift

  (valves_to_open - elem[:opened]).each do |next_node|
    weight = important[elem[:name]].important_neighbours[next_node]

    remaining_minutes = elem[:remaining_minutes] - weight - 1
    next if remaining_minutes < 0

    next_pressure = elem[:cur_released] + important[next_node].flow_rate * remaining_minutes
    opened_valves = elem[:opened].clone.append(next_node) #.sort

    key = "#{next_node}::#{opened_valves.join(",")}"
    next if visited[key] && visited[key] > next_pressure

    visited[key] = next_pressure
    queue.append({ name: next_node, opened: opened_valves, cur_released: next_pressure, remaining_minutes: remaining_minutes})
  end
end

uniq = {}
visited.each do |k, v|
  opened = k.split("::")[1].split(",").sort

  next if uniq[opened] && v < uniq[opened]

  uniq[opened] = v
end

max = 0
uniq.each do |you_opened, cur_released|
  uniq.each do |sloncek_opened, sloncek_released|
    # It would be more efficient to represent the opened valves
    # as a bit set so the AND/& operation would be very cheap
    #
    if you_opened & sloncek_opened  == []
      tmp = cur_released + sloncek_released

      max = tmp if tmp > max
    end
  end
end

puts res
