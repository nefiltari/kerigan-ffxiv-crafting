Skills = exports? and exports or @Skills = {}

## Libs

coffee = require 'coffee-script'
require 'coffee-script/register'
_ = require 'underscore'
async = require 'async'

## Code (Skills)

Mods = require './mods'
Kerigan = require 'kerigan'
Skill = Kerigan.Skill
Engine = Kerigan.Engine
Buff = Kerigan.Buff
Value = Kerigan.Value

# Basic Skills

# Basic Synthesis (1)
Skills['basic-synthesis'] = new Skill 'basic-synthesis', (engine) ->
  chance = Math.min 1.0, engine.values.success() + @state.success
  engine.state.success.install 'add', Mods['add-success'](engine, chance)
  if engine.successor chance
    progress = engine.values.progress() * @state.efficiency
    engine.state.progress.install 'add', Mods['add-progress'](engine, progress)
    engine.state.capacity.install 'use', Mods['use-capacity'](engine)
Skills['basic-synthesis'].init 0, { success: 0.9, efficiency: 1.0 }

# Basic Touch (5)
Skills['basic-touch'] = new Skill 'basic-touch', (engine) ->
  chance = Math.min 1.0, engine.values.success() + @state.success
  engine.state.success.install 'add', Mods['add-success'](engine, chance)
  if engine.successor chance
    quality = engine.values.quality() * @state.efficiency
    engine.state.quality.install 'add', Mods['add-quality'](engine, quality)
    engine.state.capacity.install 'use', Mods['use-capacity'](engine)
    engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['basic-touch'].init 18, { success: 0.7, efficiency: 1.0 }

# Master's Mend (7)
Skills['masters-mend'] = new Skill 'masters-mend', (engine) ->
  engine.state.capacity.install 'add', Mods['add-capacity'](engine, @state.bonus)
  engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['masters-mend'].init 92, { bonus: 30 }

# Steady Hand (9)
Skills['steady-hand'] = new Skill 'steady-hand', (engine) ->
  bonus = @state.bonus
  buff = new Buff 'steady-hand'
  buff.init @state.rounds, {}, 'steady-hand-ii'
  buff.install engine.values.success, (akk) -> akk + bonus
  engine.add_buff buff
  engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['steady-hand'].init 22, { bonus: 0.2, rounds: 5 }

# Inner Quiet (11)
Skills['inner-quiet'] = new Skill 'inner-quiet', (engine) ->
  buff = new Buff 'inner-quiet'
  buff.init 'infinite', { size: 1 }
  buff.install engine.state.control, (akk) -> akk + Math.floor(@base * 0.2 * buff.state.size)
  listener = (mod) ->
    if mod.id is 'add'
      buff.state.size += 1
      do buff.update
  buff.on 'add', (engine) ->
    engine.state.quality.on 'install', listener
  buff.on 'final', (engine) ->
    engine.state.quality.removeListener 'install', listener
  engine.add_buff buff
  engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['inner-quiet'].init 18

# Observe (13)
Skills['observe'] = new Skill 'observe', (engine) ->
  engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['observe'].init 14

# Standard Touch (18)
Skills['standard-touch'] = new Skill 'standard-touch', (engine) ->
  chance = Math.min 1.0, engine.values.success() + @state.success
  engine.state.success.install 'add', Mods['add-success'](engine, chance)
  if engine.successor chance
    quality = engine.values.quality() * @state.efficiency
    engine.state.quality.install 'add', Mods['add-quality'](engine, quality)
    engine.state.capacity.install 'use', Mods['use-capacity'](engine)
    engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['standard-touch'].init 32, { success: 0.8, efficiency: 1.25 }

# Great Stride (21)
Skills['great-stride'] = new Skill 'great-stride', (engine) ->
  buff = new Buff 'great-stride'
  buff.init @state.rounds
  buff.install engine.values.quality, (akk) -> akk * 2.0
  listener = (mod) ->
      engine.del_buff(buff) if mod.id is 'add'
  buff.on 'add', (engine) ->
    engine.state.quality.on 'install', listener
  buff.on 'delete', (engine) ->
    engine.state.quality.removeListener 'install', listener
  engine.add_buff buff
  engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['great-stride'].init 32, { rounds: 3 }

# Masters Mend II (25)
Skills['masters-mend-ii'] = new Skill 'masters-mend-ii', (engine) ->
  engine.state.capacity.install 'add', Mods['add-capacity'](engine, @state.bonus)
  engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['masters-mend-ii'].init 160, { bonus: 60 }

# Standard Synthesis (31)
Skills['standard-synthesis'] = new Skill 'standard-synthesis', (engine) ->
  chance = Math.min 1.0, engine.values.success() + @state.success
  engine.state.success.install 'add', Mods['add-success'](engine, chance)
  if engine.successor chance
    progress = engine.values.progress() * @state.efficiency
    engine.state.progress.install 'add', Mods['add-progress'](engine, progress)
    engine.state.capacity.install 'use', Mods['use-capacity'](engine)
    engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['standard-synthesis'].init 15, { success: 0.9, efficiency: 1.5 }

# Advanced Touch (43)
Skills['advanced-touch'] = new Skill 'advanced-touch', (engine) ->
  chance = Math.min 1.0, engine.values.success() + @state.success
  engine.state.success.install 'add', Mods['add-success'](engine, chance)
  if engine.successor chance
    quality = engine.values.quality() * @state.efficiency
    engine.state.quality.install 'add', Mods['add-quality'](engine, quality)
    engine.state.capacity.install 'use', Mods['use-capacity'](engine)
    engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['advanced-touch'].init 43, { success: 0.9, efficiency: 1.5 }

# Cross Class Skills
# Carpenter

# Rumination (15)
Skills['rumination'] = new Skill 'rumination', (engine) ->
  cps = [15, 24, 32, 39, 45, 50, 54, 57, 59]
  buff = engine.get_buff('inner-quiet')
  cp = 60
  cp = cps[buff.state.size-1] if buff.state.size < 10
  engine.del_buff buff
  engine.state.cp.install 'add', Mods['add-cp'](engine, cp)
Skills['rumination'].init 0

# Brand of Wind (37)
Skills['brand-of-wind'] = new Skill 'brand-of-wind', (engine) ->
  chance = Math.min 1.0, engine.values.success() + @state.success
  engine.state.success.install 'add', Mods['add-success'](engine, chance)
  if engine.successor chance
    progress = engine.values.progress() * @state.efficiency
    progress = progress * 2.0 if engine.state.target.affinity() is @state.affinity
    engine.state.progress.install 'add', Mods['add-progress'](engine, progress)
    engine.state.capacity.install 'use', Mods['use-capacity'](engine)
    engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['brand-of-wind'].init 15, { success: 0.9, affinity: 'wind', efficiency: 1.0 }

# Byregot's Blessing (50)
Skills['byregots-blessing'] = new Skill 'byregots-blessing', (engine) ->
  chance = Math.min 1.0, engine.values.success() + @state.success
  engine.state.success.install 'add', Mods['add-success'](engine, chance)
  if engine.successor chance
    efficiency = @state.efficiency + (0.2 * engine.get_buff('inner-quiet').state.size)
    engine.del_buff 'inner-quiet'
    quality = engine.values.quality() * efficiency
    engine.state.quality.install 'add', Mods['add-quality'](engine, quality)
    engine.state.capacity.install 'use', Mods['use-capacity'](engine)
    engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['byregots-blessing'].init 24, { success: 0.9, efficiency: 1.0 }

# Blacksmith

# Ingenuity (15)
Skills['ingenuity'] = new Skill 'ingenuity', (engine) ->
  buff = new Buff 'ingenuity'
  buff.init @state.rounds, {}, 'ingenuity-ii'
  buff.install engine.state.target.level, (akk) -> engine.state.level()
  engine.add_buff buff
  engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['ingenuity'].init 24, { rounds: 5 }

# Brand of Fire (37)
Skills['brand-of-fire'] = new Skill 'brand-of-fire', (engine) ->
  chance = Math.min 1.0, engine.values.success() + @state.success
  engine.state.success.install 'add', Mods['add-success'](engine, chance)
  if engine.successor chance
    progress = engine.values.progress() * @state.efficiency
    progress = progress * 2.0 if engine.state.target.affinity() is @state.affinity
    engine.state.progress.install 'add', Mods['add-progress'](engine, progress)
    engine.state.capacity.install 'use', Mods['use-capacity'](engine)
    engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['brand-of-fire'].init 15, { success: 0.9, affinity: 'fire', efficiency: 1.0 }

# Ingenuity II (50)
Skills['ingenuity-ii'] = new Skill 'ingenuity-ii', (engine) ->
  buff = new Buff 'ingenuity-ii'
  buff.init @state.rounds, {}, 'ingenuity'
  buff.install engine.state.target.level, (akk) -> Math.max 1, (engine.state.level() - 3)
  engine.add_buff buff
  engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['ingenuity-ii'].init 32, { rounds: 5 }

# Armorer

# Rapid Synthesis (15)
Skills['rapid-synthesis'] = new Skill 'rapid-synthesis', (engine) ->
  chance = Math.min 1.0, engine.values.success() + @state.success
  engine.state.success.install 'add', Mods['add-success'](engine, chance)
  if engine.successor chance
    progress = engine.values.progress() * @state.efficiency
    engine.state.progress.install 'add', Mods['add-progress'](engine, progress)
    engine.state.capacity.install 'use', Mods['use-capacity'](engine)
    engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['rapid-synthesis'].init 0, { success: 0.5, efficiency: 2.5 }

# Brand of Ice (37)
Skills['brand-of-ice'] = new Skill 'brand-of-ice', (engine) ->
  chance = Math.min 1.0, engine.values.success() + @state.success
  engine.state.success.install 'add', Mods['add-success'](engine, chance)
  if engine.successor chance
    progress = engine.values.progress() * @state.efficiency
    progress = progress * 2.0 if engine.state.target.affinity() is @state.affinity
    engine.state.progress.install 'add', Mods['add-progress'](engine, progress)
    engine.state.capacity.install 'use', Mods['use-capacity'](engine)
    engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['brand-of-ice'].init 15, { success: 0.9, affinity: 'ice', efficiency: 1.0 }

# Piece by Piece (50)
Skills['piece-by-piece'] = new Skill 'piece-by-piece', (engine) ->
  chance = Math.min 1.0, engine.values.success() + @state.success
  engine.state.success.install 'add', Mods['add-success'](engine, chance)
  if engine.successor chance
    remaining = engine.state.target.progress() - engine.state.progress()
    progress = Math.floor(remaining / 3.0)
    engine.state.progress.install 'add', Mods['add-progress'](engine, progress)
    engine.state.capacity.install 'use', Mods['use-capacity'](engine)
    engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['piece-by-piece'].init 15, { success: 0.9 }

# Goldsmith

# Manipulation (15)
Skills['manipulation'] = new Skill 'manipulation', (engine) ->
  buff = new Buff 'manipulation'
  buff.init @state.rounds
  buff.on 'tick', (engine) ->
    engine.state.capacity.install 'add', Mods['add-capacity'](engine, @state.bonus)
  engine.add_buff buff
  engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['steady-hand'].init 88, { rounds: 3, bonus: 10 }

# Flawless Synthesis (37)
Skills['flawless-synthesis'] = new Skill 'flawless-synthesis', (engine) ->
  chance = Math.min 1.0, engine.values.success() + @state.success
  engine.state.success.install 'add', Mods['add-success'](engine, chance)
  if engine.successor chance
    progress = @state.bonus
    engine.state.progress.install 'add', Mods['add-progress'](engine, progress)
    engine.state.capacity.install 'use', Mods['use-capacity'](engine)
    engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['flawless-synthesis'].init 15, { success: 0.9, bonus: 40 }

# Innovation (50)
Skills['innovation'] = new Skill 'innovation', (engine) ->
  buff = new Buff 'innovation'
  buff.init @state.rounds
  buff.install engine.state.control, (akk) ->
    akk + Math.floor(0.5 * engine.state.control.base)
  engine.add_buff buff
  engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['innovation'].init 18, { rounds: 3 }

# Leatherworker

# Waste Not (15)
Skills['waste-not'] = new Skill 'waste-not', (engine) ->
  buff = new Buff 'waste-not'
  buff.init @state.rounds, {}, 'waste-not-ii'
  buff.install engine.values.capacity, (akk) -> Math.floor(akk * 0.5)
  engine.add_buff buff
  engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['waste-not'].init 56, { rounds: 4 }

# Brand of Earth (37)
Skills['brand-of-earth'] = new Skill 'brand-of-earth', (engine) ->
  chance = Math.min 1.0, engine.values.success() + @state.success
  engine.state.success.install 'add', Mods['add-success'](engine, chance)
  if engine.successor chance
    progress = engine.values.progress() * @state.efficiency
    progress = progress * 2.0 if engine.state.target.affinity() is @state.affinity
    engine.state.progress.install 'add', Mods['add-progress'](engine, progress)
    engine.state.capacity.install 'use', Mods['use-capacity'](engine)
    engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['brand-of-earth'].init 15, { success: 0.9, affinity: 'earth', efficiency: 1.0 }

# Waste Not II (50)
Skills['waste-not-ii'] = new Skill 'waste-not-ii', (engine) ->
  buff = new Buff 'waste-not-ii'
  buff.init @state.rounds, {}, 'waste-not'
  buff.install engine.values.capacity, (akk) -> Math.floor(akk * 0.5)
  engine.add_buff buff
  engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['waste-not-ii'].init 98, { rounds: 8 }

# Weaver

# Careful Synthesis (15)
Skills['careful-synthesis'] = new Skill 'careful-synthesis', (engine) ->
  progress = engine.values.progress() * @state.efficiency
  engine.state.progress.install 'add', Mods['add-progress'](engine, progress)
  engine.state.capacity.install 'use', Mods['use-capacity'](engine)
Skills['careful-synthesis'].init 0, { success: 1.0, efficiency: 0.9 }

# Brand of Lightning (37)
Skills['brand-of-lightning'] = new Skill 'brand-of-ligthning', (engine) ->
  chance = Math.min 1.0, engine.values.success() + @state.success
  engine.state.success.install 'add', Mods['add-success'](engine, chance)
  if engine.successor chance
    progress = engine.values.progress() * @state.efficiency
    progress = progress * 2.0 if engine.state.target.affinity() is @state.affinity
    engine.state.progress.install 'add', Mods['add-progress'](engine, progress)
    engine.state.capacity.install 'use', Mods['use-capacity'](engine)
    engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['brand-of-lightning'].init 15, { success: 0.9, affinity: 'lightning', efficiency: 1.0 }

# Careful Synthesis II (50)
Skills['careful-synthesis-ii'] = new Skill 'careful-synthesis-ii', (engine) ->
  progress = engine.values.progress() * @state.efficiency
  engine.state.progress.install 'add', Mods['add-progress'](engine, progress)
  engine.state.capacity.install 'use', Mods['use-capacity'](engine)
Skills['careful-synthesis-ii'].init 0, { success: 1.0, efficiency: 1.2 }

# Alchemist

# Tricks of the Trade (15)
Skills['tricks-of-the-trade'] = new Skill 'tricks-of-the-trade', (engine) ->
  cp = @state.bonus
  engine.state.cp.install 'add', Mods['add-cp'](engine, cp)
Skills['tricks-of-the-trade'].init 0, { bonus: 20 }

# Brand of Water (37)
Skills['brand-of-water'] = new Skill 'brand-of-water', (engine) ->
  chance = Math.min 1.0, engine.values.success() + @state.success
  engine.state.success.install 'add', Mods['add-success'](engine, chance)
  if engine.successor chance
    progress = engine.values.progress() * @state.efficiency
    progress = progress * 2.0 if engine.state.target.affinity() is @state.affinity
    engine.state.progress.install 'add', Mods['add-progress'](engine, progress)
    engine.state.capacity.install 'use', Mods['use-capacity'](engine)
    engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['brand-of-water'].init 15, { success: 0.9, affinity: 'water', efficiency: 1.0 }

# Comfort Zone (50)
Skills['comfort-zone'] = new Skill 'comfort-zone', (engine) ->
  buff = new Buff 'comfort-zone'
  buff.init @state.rounds
  cp = @state.bonus
  buff.on 'tick', (engine) ->
    engine.state.cp.install 'add', Mods['add-cp'](engine, cp)
  engine.add_buff buff
  engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['comfort-zone'].init 66, { rounds: 10, bonus: 8 }

# Culinarian

# Hasty Touch (15)
Skills['hasty-touch'] = new Skill 'hasty-touch', (engine) ->
  chance = Math.min 1.0, engine.values.success() + @state.success
  engine.state.success.install 'add', Mods['add-success'](engine, chance)
  if engine.successor chance
    quality = engine.values.quality() * @state.efficiency
    engine.state.quality.install 'add', Mods['add-quality'](engine, quality)
    engine.state.capacity.install 'use', Mods['use-capacity'](engine)
    engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['hasty-touch'].init 0, { success: 0.5, efficiency: 1.0 }

# Steady Hand II (37)
Skills['steady-hand-ii'] = new Skill 'steady-hand-ii', (engine) ->
  bonus = @state.bonus
  buff = new Buff 'steady-hand-ii'
  buff.init @state.rounds, {}, 'steady-hand'
  buff.install engine.values.success, (akk) -> akk + bonus
  engine.add_buff buff
  engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['steady-hand-ii'].init 25, { bonus: 0.3, rounds: 5 }

# Reclaim (50)
Skills['reclaim'] = new Skill 'reclaim', (engine) ->
  # The simulator ignores the fact that materials can be regained
  # But the cost for cp will withdrawed however :)
  buff = new Buff 'reclaim'
  buff.init 'infinite'
  engine.add_buff buff
  engine.state.cp.install 'sub', Mods['sub-cp'](engine, @cost)
Skills['reclaim'].init 55

###
  Buffs with special state:
    'inner_quite'
      state:
        - size: Stack Counter
###