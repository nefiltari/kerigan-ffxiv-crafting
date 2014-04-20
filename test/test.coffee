## Libs

coffee = require 'coffee-script'
require 'coffee-script/register'
_ = require 'underscore'
async = require 'async'

## Code

Craft = require('../index')
engine = new Craft.Engine
  without_condition: true
  best_case: true
  ##  worst case: true
skills = Craft.skills

engine.init
  craftmanship: 359
  control: 303
  cp: 345
  level: 50
  target:
    quality: 2921
    progress: 116
    level: 50
    capacity: 40
    affinity: 'earth'

engine.next skills['comfort-zone']
engine.next skills['inner-quiet']
engine.next skills['steady-hand-ii']
engine.next skills['waste-not']
engine.next skills['basic-touch']
#engine.next skills['basic-touch']
#engine.next skills['standard-synthesis']
#engine.next skills['byregots-blessing']

# Engine Log
console.log engine
#console.log engine.values.success