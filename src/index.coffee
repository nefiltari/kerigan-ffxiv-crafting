Craft = exports? and exports or @Craft = {}

## Libs

coffee = require 'coffee-script'
require 'coffee-script/register'
_ = require 'underscore'
async = require 'async'

## Code

Kerigan = require 'kerigan'
Skill = Kerigan.Skill
Engine = Kerigan.Engine
Buff = Kerigan.Buff
Value = Kerigan.Value
successor = Kerigan.successor

# Mods
Craft.mods = require './mods'

# Skills
Craft.skills = require './skills'

# Engine
Craft.Engine = ->
  eg = Engine.call @

  # The validation function
  eg.on 'validation', (engine, skill, next) ->
    state = engine.state
    # Skill abort conditions
    conditions = [
      state.cp() < skill.cost,
      skill.id is 'tricks_of_the_trade' and state.condition() isnt 1.5,
      (skill.id is 'rumination' or skill.id is 'byregots_blessing') and engine.get_buff('inner_quite')?[0].state.size < 2
    ]
    next(not _.inject conditions, ((akk, cond) -> akk or cond), false)

  # Check if the engine is finished
  eg.on 'check-finish', (engine) ->
    state = engine.state
    # Finishes Sequenz Conditions
    cond = [
      state.capacity() is 0,
      state.target.progress() is state.progress()
    ]
    engine.finished = _.inject cond, ((memo, ele) -> memo or ele), false

  # Variable the crafting condition with rng (turn off this option with without_condition: true)
  eg.on 'next', (engine) ->
    unless engine.state.without_condition? and engine.state.without_condition
      return engine.state.condition.install 'normal', ((akk) -> 1.0) if engine.state.condition() is 1.5 or engine.state.condition() is 0.5
      return engine.state.condition.install 'poor', ((akk) -> 0.5) if engine.state.condition() is 4.0
      success = do successor
      return engine.state.condition.install 'excellent', ((akk) -> 4.0) if success <= 0.05
      return engine.state.condition.install 'good', ((akk) -> 1.5) if success <= 0.25

  # Additional initializations
  eg.on 'init', (engine) ->
    # Stateful Values
    # The Max Quality (require!)
    engine.state.target.quality = new Value 'tquality', engine.state.target.quality
    # The Max Progress (require!)
    engine.state.target.progress = new Value 'tprogress', engine.state.target.progress
    # The current capacity
    engine.state.capacity = new Value 'capacity', engine.state.capacity or engine.state.target.capacity
    # The Max Capacity (require!)
    engine.state.target.capacity = new Value 'tcapacity', engine.state.target.capacity
    # The recipe level (needed for calculate extra bonuses/panalities) (require!)
    engine.state.target.level = new Value 'tlevel', engine.state.target.level
    # The recipe affinity (wind, water, fire, lightning, ice) (Works as Array or single value)
    engine.state.target.affinity = new Value 'taffinity', engine.state.target.affinity
    # Current crafting points (CP) (require!)
    engine.state.cp = new Value 'cp', engine.state.cp
    # Current craftmanship (require!)
    engine.state.craftmanship = new Value 'craftmanship', engine.state.craftmanship
    # Current control (require!)
    engine.state.control = new Value 'control', engine.state.control
    # The own job level (require!)
    engine.state.level = new Value 'level', engine.state.level
    # Current crafting quality (set in init to an value for start quality)
    engine.state.quality = new Value 'quality', engine.state.quality or 0
    # Current HQ value
    engine.state.hq = new Value 'hq', engine
    engine.state.hq.install 'processor', Craft.mods['processor-hq'] # Converter
    engine.state.quality.on 'install', (mod) -> do engine.state.hq.update if mod.id is 'add'
    #Current crafting progress
    engine.state.progress = new Value 'progress', engine.state.progress or 0
    # The crafting condition (in multiplactive numbers: 0.5, 1.0, 1.5, 4.0)
    engine.state.condition = new Value 'condition', engine.state.condition or 1.0

    # Internal
    engine.state.success = new Value 'success', 1.0

    # Calculated Values
    # Quality processor
    engine.values.quality = new Value 'quality', engine
    engine.values.quality.install 'processor', Craft.mods['processor-quality']
    # Progress processor
    engine.values.progress = new Value 'progress', engine
    engine.values.progress.install 'processor', Craft.mods['processor-progress']
    # Capacity processor
    engine.values.capacity = new Value 'capacity', 10
    # Success bonus processor
    engine.values.success = new Value 'success', 0.0


  eg