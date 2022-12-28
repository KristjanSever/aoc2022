require 'set'
regex = /Valve (?<name>.*) has flow rate=(?<flow_rate>\d*); tunnels? leads? to valves? (?<valves>.*)\n?/
# Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
class Valve
  attr_accessor :valves, :name, :flow_rate
  def initialize(name, flow_rate, valves)
    @name = name
    @flow_rate = flow_rate.to_i
    @valves = valves.split(", ")
  end

  def config_neighbours(valves_hash)
    @valves = valves.map do |name|
      valves_hash[name]
    end
  end
end

def biggest_possible_remaining(opened_valves)
  max = $valves.reject { |k, v| opened_valves.include?(v.name) }.map{ |k, v| v.flow_rate }.max
  max || 1
end

def params_to_s(cur_valve, minutes, cur_released, opened_valves)
  "#{cur_valve.name}::#{minutes}::#{opened_valves.join(",")}"
end

def find_most_pressure(cur_valve, remaining_minutes, cur_released, opened_valves)
  cache_id = params_to_s(cur_valve, remaining_minutes, cur_released, opened_valves)
  if $cache[cache_id]
    return $cache[cache_id]
  end

  return cur_released if remaining_minutes.zero?

  max = -Float::INFINITY

  # tmp = $valves.select { |k, v| opened_valves.include?(v.name) }.map{ |k, v| v.flow_rate }.sum

  cur_valve.valves.each do |next_valve|
    # open cur valve path if enough time and not opened yet
    if next_valve.flow_rate != 0 && !opened_valves.include?(next_valve.name) && remaining_minutes > 1
      opened = find_most_pressure(next_valve,
                                              remaining_minutes - 2,
                                              cur_released + (remaining_minutes - 2) * next_valve.flow_rate,
                                              opened_valves.clone.append(next_valve.name))
    end

    # leave closed cur valve path
    closed = find_most_pressure(next_valve, remaining_minutes - 1, cur_released, opened_valves)

    max = opened if opened && opened > max
    max = closed if closed && closed > max
  end

  cache_id = params_to_s(cur_valve, remaining_minutes, cur_released, opened_valves)
  $cache[cache_id] = max
  max
end

$valves = {}
while (l = gets)
  m = l.match(regex)
  $valves[m["name"]] = Valve.new(m["name"], m["flow_rate"], m["valves"])
end
$valves.each do |k, v|
  v.config_neighbours($valves)
end

$cache = {}

start = $valves["AA"]
time_left = 30
res = find_most_pressure(start, time_left, 0, [])
binding.irb