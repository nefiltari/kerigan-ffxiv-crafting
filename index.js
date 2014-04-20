// Generated by CoffeeScript 1.7.1
(function() {
  var Buff, Craft, Engine, Kerigan, Skill, Value, async, coffee, successor, _;

  Craft = (typeof exports !== "undefined" && exports !== null) && exports || (this.Craft = {});

  coffee = require('coffee-script');

  require('coffee-script/register');

  _ = require('underscore');

  async = require('async');

  Kerigan = require('kerigan');

  Skill = Kerigan.Skill;

  Engine = Kerigan.Engine;

  Buff = Kerigan.Buff;

  Value = Kerigan.Value;

  successor = Kerigan.successor;

  Craft.mods = require('./mods');

  Craft.skills = require('./skills');

  Craft.Engine = function(config) {
    var eg;
    if (config == null) {
      config = {};
    }
    eg = Engine.call(this);
    eg.config = config;
    eg.on('validation', function(engine, skill, next) {
      var conditions, state, _ref;
      state = engine.state;
      conditions = [state.cp() < skill.cost, skill.id === 'tricks_of_the_trade' && state.condition() !== 1.5, (skill.id === 'rumination' || skill.id === 'byregots_blessing') && ((_ref = engine.get_buff('inner_quite')) != null ? _ref[0].state.size : void 0) < 2];
      return next(!_.inject(conditions, (function(akk, cond) {
        return akk || cond;
      }), false));
    });
    eg.on('check-finish', function(engine) {
      var cond, state;
      state = engine.state;
      cond = [state.capacity() === 0, state.target.progress() === state.progress()];
      return engine.finished = _.inject(cond, (function(memo, ele) {
        return memo || ele;
      }), false);
    });
    eg.on('next', function(engine) {
      var success;
      if (!((eg.config.without_condition != null) && eg.config.without_condition)) {
        if (engine.state.condition() === 1.5 || engine.state.condition() === 0.5) {
          return engine.state.condition.install('normal', (function(akk) {
            return 1.0;
          }));
        }
        if (engine.state.condition() === 4.0) {
          return engine.state.condition.install('poor', (function(akk) {
            return 0.5;
          }));
        }
        success = successor();
        if (success <= 0.05) {
          return engine.state.condition.install('excellent', (function(akk) {
            return 4.0;
          }));
        }
        if (success <= 0.25) {
          return engine.state.condition.install('good', (function(akk) {
            return 1.5;
          }));
        }
      }
    });
    eg.on('init', function(engine) {
      engine.state.target.quality = new Value('tquality', engine.state.target.quality);
      engine.state.target.progress = new Value('tprogress', engine.state.target.progress);
      engine.state.capacity = new Value('capacity', engine.state.capacity || engine.state.target.capacity);
      engine.state.target.capacity = new Value('tcapacity', engine.state.target.capacity);
      engine.state.target.level = new Value('tlevel', engine.state.target.level);
      engine.state.target.affinity = new Value('taffinity', engine.state.target.affinity);
      engine.state.cp = new Value('cp', engine.state.cp);
      engine.state.craftmanship = new Value('craftmanship', engine.state.craftmanship);
      engine.state.control = new Value('control', engine.state.control);
      engine.state.level = new Value('level', engine.state.level);
      engine.state.quality = new Value('quality', engine.state.quality || 0);
      engine.state.hq = new Value('hq', engine);
      engine.state.hq.install('processor', Craft.mods['processor-hq']);
      engine.state.quality.on('install', function(mod) {
        if (mod.id === 'add') {
          return engine.state.hq.update();
        }
      });
      engine.state.progress = new Value('progress', engine.state.progress || 0);
      engine.state.condition = new Value('condition', engine.state.condition || 1.0);
      engine.state.success = new Value('success', 1.0);
      engine.values.quality = new Value('quality', engine);
      engine.values.quality.install('processor', Craft.mods['processor-quality']);
      engine.values.progress = new Value('progress', engine);
      engine.values.progress.install('processor', Craft.mods['processor-progress']);
      engine.values.capacity = new Value('capacity', 10);
      return engine.values.success = new Value('success', 0.0);
    });
    return eg;
  };

}).call(this);
