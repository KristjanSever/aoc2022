require "set"

def read_state(state)
  {
    n_ore: state[0], n_clay: state[1], n_obs: state[2], n_geode: state[3],
    r_ore: state[4], r_clay: state[5], r_obs: state[6], r_geode: state[7], minutes: state[8]
  }
end

def solve(blueprint, time)
  visited = Set.new
  best = 0
  minutes = time
  # (n_ore, n_clay, n_obs, n_geode, n_ore_robots, n_clay_robots, n_obs_robots, n_geode_robots, blueprint, minutes)
  queue = [[0, 0, 0, 0, # num of resources
            1, 0, 0, 0, minutes]]

  max_spend = [[blueprint.ore_r_o, blueprint.clay_r_o, blueprint.obs_r_o, blueprint.geo_r_o].max,
                blueprint.obs_r_c,
                blueprint.geo_r_obs]

  i = 0
  while !queue.empty?
    state = queue.shift
    state_hash = read_state(state)

    n_ore = state_hash[:n_ore]
    n_clay = state_hash[:n_clay]
    n_obs = state_hash[:n_obs]
    n_geode = state_hash[:n_geode]
    r_ore = state_hash[:r_ore]
    r_clay = state_hash[:r_clay]
    r_obs = state_hash[:r_obs]
    r_geode = state_hash[:r_geode]
    minutes = state_hash[:minutes]

    r_ore = [r_ore, max_spend[0]].min
    r_clay = [r_clay, max_spend[1]].min
    r_obs = [r_obs, max_spend[2]].min
    # no point in having more resources than you can spend
    # best case scenario you spend the maximum amount you can per minute (minutes * max_spend)
    # this is reduced by the amout of ore you are already producing
    n_ore = [n_ore, minutes * max_spend[0] - r_ore * (minutes - 1)].min
    n_clay = [n_clay, minutes * max_spend[1] - r_clay * (minutes - 1)].min
    n_obs = [n_obs, minutes * max_spend[2] - r_obs * (minutes - 1)].min

    best = [best, n_geode].max

    next if !visited.add?(state) # this will add to visited as well
    next if minutes == 0

    i += 1
    new_state = [n_ore + r_ore, n_clay + r_clay, n_obs + r_obs, n_geode + r_geode,
                 r_ore, r_clay, r_obs, r_geode, minutes - 1]

    queue.append(new_state)

    if n_ore >= blueprint.geo_r_o && n_obs >= blueprint.geo_r_obs
      new_state = [n_ore + r_ore - blueprint.geo_r_o, n_clay + r_clay, n_obs + r_obs - blueprint.geo_r_obs, n_geode + r_geode,
                   r_ore, r_clay, r_obs, r_geode + 1, minutes - 1]
      queue.append(new_state)
    end

    if n_ore >= blueprint.obs_r_o && n_clay >= blueprint.obs_r_c
      new_state = [n_ore + r_ore - blueprint.obs_r_o, n_clay + r_clay - blueprint.obs_r_c, n_obs + r_obs, n_geode + r_geode,
                   r_ore, r_clay, r_obs + 1, r_geode, minutes - 1]
      queue.append(new_state)
    end

    if n_ore >= blueprint.clay_r_o
      new_state = [n_ore + r_ore - blueprint.clay_r_o, n_clay + r_clay, n_obs + r_obs, n_geode + r_geode,
                   r_ore, r_clay + 1, r_obs, r_geode, minutes - 1]
      queue.append(new_state)
    end

    if n_ore >= blueprint.ore_r_o
      new_state = [n_ore + r_ore - blueprint.ore_r_o, n_clay + r_clay, n_obs + r_obs, n_geode + r_geode,
                   r_ore + 1, r_clay, r_obs, r_geode, minutes - 1]
      queue.append(new_state)
    end
  end
  best
end

regex = %r{Blueprint (?<num>.*): Each ore robot costs (?<ore_num>.*) ore. Each clay robot costs (?<clay_num>.*) ore. Each obsidian robot costs (?<obs_ore>.*) ore and (?<obs_clay>.*) clay. Each geode robot costs (?<geode_ore>.*) ore and (?<geode_obs>.*) obsidian.\n?}
Robot = Struct.new(:num_of, :collected_resource)
Blueprint = Struct.new(:num, :ore_r_o, :clay_r_o, :obs_r_o, :obs_r_c, :geo_r_o, :geo_r_obs)
blueprints = []
while (l = gets)
  match = l.match(regex)
  blueprints.append(Blueprint.new(match["num"].to_i, match["ore_num"].to_i, match["clay_num"].to_i, match["obs_ore"].to_i, match["obs_clay"].to_i, match["geode_ore"].to_i, match["geode_obs"].to_i))
end

time_1 = 24
time_2 = 32
res_1 = 0
res_2 = 1
blueprints.each.with_index do |blueprint, index|
  res_1 += blueprint.num * solve(blueprint, time_1)
  res_2 *= solve(blueprint, time_2) if index < 3
  puts("blueprint #{index} done")
end
# takes a long time
puts res_1
puts res_2