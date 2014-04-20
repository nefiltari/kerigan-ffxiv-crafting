## Libs

coffee = require 'coffee-script'
require 'coffee-script/register'
_ = require 'underscore'
async = require 'async'

## Code

Craft = require('../index')
engine = new Craft.Engine
  without_condition: true
##  lucky_strike: true
skills = Craft.skills

engine.init
  craftmanship: 347
  control: 330
  cp: 365
  level: 50
  target:
    quality: 2921
    progress: 116
    level: 55
    capacity: 40
    affinity: 'earth'

engine.next skills['comfort-zone']
engine.next skills['inner-quiet']
engine.next skills['steady-hand']
engine.next skills['waste-not']
engine.next skills['basic-touch']
engine.next skills['basic-touch']
engine.next skills['basic-synthesis']

# Engine Log
console.log engine
#console.log engine.values.success