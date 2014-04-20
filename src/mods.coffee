Mods = exports? and exports or @Mods = {}

## Libs

coffee = require 'coffee-script'
require 'coffee-script/register'
_ = require 'underscore'
async = require 'async'

## Code (Mods)

# Processor Mods (to calculate engine.values or cross state values)
# Prefix: processor

# Calculates used quality
Mods['processor-quality'] = (engine) ->
  control = engine.state.control()
  quality = 3.4275521095175201e+001 + 3.558806693020045e-001 * control + 3.5279187952857053e-005 * control * control
  # With crafting condition
  quality *= engine.state.condition()
  # Calculate penality (capped maximal to 5 level over job level) (Quality has no bonus)
  modifier = 1.0 - 0.05 * Math.min(Math.max(engine.state.target.level() - engine.state.level(), 0), 5)
  quality *= modifier

# Thats is the value inverse function from Q(HQ) because there exist no mathematical representation for HQ(Q)
# R^2 = 0.9986
hqs = _.times 101, (percent) -> (-0.0000056604 * percent**4 + 0.0015369705 * percent**3 - 0.1426469573 * percent**2 + 5.6122722959 * percent - 5.5950384565)
#console.log hqs

# Find the value in O(LOG N) or O(7) by hqs
binary_search_hqs = (a, b, v) ->
  if (b - a) is 1
    hq = ((v - hqs[a]) / (hqs[b] - hqs[a])) + a
    return hq
  middle = Math.floor((b - a) / 2.0) + a
  if v < hqs[middle]
    binary_search_hqs a, middle, v
  else if v > hqs[middle]
    binary_search_hqs middle, b, v
  else middle

# Calculates HQ propability from quality
Mods['processor-hq'] = (engine) ->
  percent = (engine.state.quality() / engine.state.target.quality()) * 100
  binary_search_hqs 1, 100, percent

# Calculates used progress
Mods['processor-progress'] = (engine) ->
  craftmanship = engine.state.craftmanship()
  progress = (54/256) * craftmanship + (330/256)
  # Calculate bonus/penality (capped to 5 level over or under job level)
  diff = engine.state.target.level() - engine.state.level()
  diff = 5 if diff > 5
  modifier = 1
  modifier -=
    if diff > 0
      0.10 * diff
    else if diff > -6
      0.05 * diff
    else
      0.022 * diff
  progress *= modifier

# Normal Mods
# Prefixes: add, sub, use

# Mod that creates add quality mod
Mods['add-quality'] = (engine, quality) ->
  quality = Math.round quality
  max = engine.state.target.quality()
  (akk) -> Math.min max, akk + quality

# Mod that creates add progress mod
Mods['add-progress'] = (engine, progress) ->
  progress = Math.round progress
  max = engine.state.target.progress()
  (akk) -> Math.min max, akk + progress

# Mod that creates use capacity mod ('use' means the use of an engine.values value)
Mods['use-capacity'] = (engine) ->
  capacity = engine.values.capacity()
  (akk) -> Math.max 0, akk - capacity

# Mod that creates add capacity mod
Mods['add-capacity'] = (engine, capacity) ->
  max = engine.state.target.capacity()
  (akk) -> Math.min max, akk + capacity

# Mod that creates a mod for calculated success chance (over all skills)
Mods['add-success'] = (engine, success) ->
  (akk) -> akk * success

# Mod that creates a mod for accept the skill cost
Mods['sub-cp'] = (engine, cp) ->
  (akk) -> akk - cp

# Mod that creates a mod for add cp
Mods['add-cp'] = (engine, cp) ->
  max = engine.state.cp.base
  (akk) -> Math.min max, akk + cp