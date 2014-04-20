// Generated by CoffeeScript 1.7.1
(function() {
  var Buff, Engine, Kerigan, Mods, Skill, Skills, Value, async, coffee, _;

  Skills = (typeof exports !== "undefined" && exports !== null) && exports || (this.Skills = {});

  coffee = require('coffee-script');

  require('coffee-script/register');

  _ = require('underscore');

  async = require('async');

  Mods = require('./mods');

  Kerigan = require('kerigan');

  Skill = Kerigan.Skill;

  Engine = Kerigan.Engine;

  Buff = Kerigan.Buff;

  Value = Kerigan.Value;

  Skills['basic-synthesis'] = new Skill('basic-synthesis', function(engine) {
    var chance, progress;
    chance = Math.min(1.0, engine.values.success() + this.state.success);
    engine.state.success.install('add', Mods['add-success'](engine, chance));
    if (engine.successor(chance)) {
      progress = engine.values.progress() * this.state.efficiency;
      engine.state.progress.install('add', Mods['add-progress'](engine, progress));
      return engine.state.capacity.install('use', Mods['use-capacity'](engine));
    }
  });

  Skills['basic-synthesis'].init(0, {
    success: 0.9,
    efficiency: 1.0
  });

  Skills['basic-touch'] = new Skill('basic-touch', function(engine) {
    var chance, quality;
    chance = Math.min(1.0, engine.values.success() + this.state.success);
    engine.state.success.install('add', Mods['add-success'](engine, chance));
    if (engine.successor(chance)) {
      quality = engine.values.quality() * this.state.efficiency;
      engine.state.quality.install('add', Mods['add-quality'](engine, quality));
      engine.state.capacity.install('use', Mods['use-capacity'](engine));
      return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
    }
  });

  Skills['basic-touch'].init(18, {
    success: 0.7,
    efficiency: 1.0
  });

  Skills['masters-mend'] = new Skill('masters-mend', function(engine) {
    engine.state.capacity.install('add', Mods['add-capacity'](engine, this.state.bonus));
    return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
  });

  Skills['masters-mend'].init(92, {
    bonus: 30
  });

  Skills['steady-hand'] = new Skill('steady-hand', function(engine) {
    var bonus, buff;
    bonus = this.state.bonus;
    buff = new Buff('steady-hand');
    buff.init(this.state.rounds, {}, 'steady-hand-ii');
    buff.install(engine.values.success, function(akk) {
      return akk + bonus;
    });
    engine.add_buff(buff);
    return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
  });

  Skills['steady-hand'].init(22, {
    bonus: 0.2,
    rounds: 5
  });

  Skills['inner-quiet'] = new Skill('inner-quiet', function(engine) {
    var buff, listener;
    buff = new Buff('inner-quiet');
    buff.init('infinite', {
      size: 1
    });
    buff.install(engine.state.control, function(akk) {
      return akk + Math.floor(this.base * 0.2 * buff.state.size);
    });
    listener = function(mod) {
      if (mod.id === 'add') {
        buff.state.size += 1;
        return buff.update();
      }
    };
    buff.on('add', function(engine) {
      return engine.state.quality.on('install', listener);
    });
    buff.on('final', function(engine) {
      return engine.state.quality.removeListener('install', listener);
    });
    engine.add_buff(buff);
    return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
  });

  Skills['inner-quiet'].init(18);

  Skills['observe'] = new Skill('observe', function(engine) {
    return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
  });

  Skills['observe'].init(14);

  Skills['standard-touch'] = new Skill('standard-touch', function(engine) {
    var chance, quality;
    chance = Math.min(1.0, engine.values.success() + this.state.success);
    engine.state.success.install('add', Mods['add-success'](engine, chance));
    if (engine.successor(chance)) {
      quality = engine.values.quality() * this.state.efficiency;
      engine.state.quality.install('add', Mods['add-quality'](engine, quality));
      engine.state.capacity.install('use', Mods['use-capacity'](engine));
      return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
    }
  });

  Skills['standard-touch'].init(32, {
    success: 0.8,
    efficiency: 1.25
  });

  Skills['great-stride'] = new Skill('great-stride', function(engine) {
    var buff, listener;
    buff = new Buff('great-stride');
    buff.init(this.state.rounds);
    buff.install(engine.values.quality, function(akk) {
      return akk * 2.0;
    });
    listener = function(mod) {
      if (mod.id === 'add') {
        return engine.del_buff(buff);
      }
    };
    buff.on('add', function(engine) {
      return engine.state.quality.on('install', listener);
    });
    buff.on('delete', function(engine) {
      return engine.state.quality.removeListener('install', listener);
    });
    engine.add_buff(buff);
    return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
  });

  Skills['great-stride'].init(32, {
    rounds: 3
  });

  Skills['masters-mend-ii'] = new Skill('masters-mend-ii', function(engine) {
    engine.state.capacity.install('add', Mods['add-capacity'](engine, this.state.bonus));
    return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
  });

  Skills['masters-mend-ii'].init(160, {
    bonus: 60
  });

  Skills['standard-synthesis'] = new Skill('standard-synthesis', function(engine) {
    var chance, progress;
    chance = Math.min(1.0, engine.values.success() + this.state.success);
    engine.state.success.install('add', Mods['add-success'](engine, chance));
    if (engine.successor(chance)) {
      progress = engine.values.progress() * this.state.efficiency;
      engine.state.progress.install('add', Mods['add-progress'](engine, progress));
      engine.state.capacity.install('use', Mods['use-capacity'](engine));
      return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
    }
  });

  Skills['standard-synthesis'].init(15, {
    success: 0.9,
    efficiency: 1.5
  });

  Skills['advanced-touch'] = new Skill('advanced-touch', function(engine) {
    var chance, quality;
    chance = Math.min(1.0, engine.values.success() + this.state.success);
    engine.state.success.install('add', Mods['add-success'](engine, chance));
    if (engine.successor(chance)) {
      quality = engine.values.quality() * this.state.efficiency;
      engine.state.quality.install('add', Mods['add-quality'](engine, quality));
      engine.state.capacity.install('use', Mods['use-capacity'](engine));
      return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
    }
  });

  Skills['advanced-touch'].init(43, {
    success: 0.9,
    efficiency: 1.5
  });

  Skills['rumination'] = new Skill('rumination', function(engine) {
    var buff, cp, cps;
    cps = [15, 24, 32, 39, 45, 50, 54, 57, 59];
    buff = engine.get_buff('inner-quiet');
    cp = 60;
    if (buff.state.size < 10) {
      cp = cps[buff.state.size - 1];
    }
    engine.del_buff(buff);
    return engine.state.cp.install('add', Mods['add-cp'](engine, cp));
  });

  Skills['rumination'].init(0);

  Skills['brand-of-wind'] = new Skill('brand-of-wind', function(engine) {
    var chance, progress;
    chance = Math.min(1.0, engine.values.success() + this.state.success);
    engine.state.success.install('add', Mods['add-success'](engine, chance));
    if (engine.successor(chance)) {
      progress = engine.values.progress() * this.state.efficiency;
      if (engine.state.target.affinity() === this.state.affinity) {
        progress = progress * 2.0;
      }
      engine.state.progress.install('add', Mods['add-progress'](engine, progress));
      engine.state.capacity.install('use', Mods['use-capacity'](engine));
      return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
    }
  });

  Skills['brand-of-wind'].init(15, {
    success: 0.9,
    affinity: 'wind',
    efficiency: 1.0
  });

  Skills['byregots-blessing'] = new Skill('byregots-blessing', function(engine) {
    var chance, efficiency, quality;
    chance = Math.min(1.0, engine.values.success() + this.state.success);
    engine.state.success.install('add', Mods['add-success'](engine, chance));
    if (engine.successor(chance)) {
      efficiency = this.state.efficiency + (0.2 * engine.get_buff('inner-quiet').state.size);
      engine.del_buff('inner-quiet');
      quality = engine.values.quality() * efficiency;
      engine.state.quality.install('add', Mods['add-quality'](engine, quality));
      engine.state.capacity.install('use', Mods['use-capacity'](engine));
      return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
    }
  });

  Skills['byregots-blessing'].init(24, {
    success: 0.9,
    efficiency: 1.0
  });

  Skills['ingenuity'] = new Skill('ingenuity', function(engine) {
    var buff;
    buff = new Buff('ingenuity');
    buff.init(this.state.rounds, {}, 'ingenuity-ii');
    buff.install(engine.state.target.level, function(akk) {
      return engine.state.level();
    });
    engine.add_buff(buff);
    return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
  });

  Skills['ingenuity'].init(24, {
    rounds: 5
  });

  Skills['brand-of-fire'] = new Skill('brand-of-fire', function(engine) {
    var chance, progress;
    chance = Math.min(1.0, engine.values.success() + this.state.success);
    engine.state.success.install('add', Mods['add-success'](engine, chance));
    if (engine.successor(chance)) {
      progress = engine.values.progress() * this.state.efficiency;
      if (engine.state.target.affinity() === this.state.affinity) {
        progress = progress * 2.0;
      }
      engine.state.progress.install('add', Mods['add-progress'](engine, progress));
      engine.state.capacity.install('use', Mods['use-capacity'](engine));
      return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
    }
  });

  Skills['brand-of-fire'].init(15, {
    success: 0.9,
    affinity: 'fire',
    efficiency: 1.0
  });

  Skills['ingenuity-ii'] = new Skill('ingenuity-ii', function(engine) {
    var buff;
    buff = new Buff('ingenuity-ii');
    buff.init(this.state.rounds, {}, 'ingenuity');
    buff.install(engine.state.target.level, function(akk) {
      return Math.max(1, engine.state.level() - 3);
    });
    engine.add_buff(buff);
    return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
  });

  Skills['ingenuity-ii'].init(32, {
    rounds: 5
  });

  Skills['rapid-synthesis'] = new Skill('rapid-synthesis', function(engine) {
    var chance, progress;
    chance = Math.min(1.0, engine.values.success() + this.state.success);
    engine.state.success.install('add', Mods['add-success'](engine, chance));
    if (engine.successor(chance)) {
      progress = engine.values.progress() * this.state.efficiency;
      engine.state.progress.install('add', Mods['add-progress'](engine, progress));
      engine.state.capacity.install('use', Mods['use-capacity'](engine));
      return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
    }
  });

  Skills['rapid-synthesis'].init(0, {
    success: 0.5,
    efficiency: 2.5
  });

  Skills['brand-of-ice'] = new Skill('brand-of-ice', function(engine) {
    var chance, progress;
    chance = Math.min(1.0, engine.values.success() + this.state.success);
    engine.state.success.install('add', Mods['add-success'](engine, chance));
    if (engine.successor(chance)) {
      progress = engine.values.progress() * this.state.efficiency;
      if (engine.state.target.affinity() === this.state.affinity) {
        progress = progress * 2.0;
      }
      engine.state.progress.install('add', Mods['add-progress'](engine, progress));
      engine.state.capacity.install('use', Mods['use-capacity'](engine));
      return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
    }
  });

  Skills['brand-of-ice'].init(15, {
    success: 0.9,
    affinity: 'ice',
    efficiency: 1.0
  });

  Skills['piece-by-piece'] = new Skill('piece-by-piece', function(engine) {
    var chance, progress, remaining;
    chance = Math.min(1.0, engine.values.success() + this.state.success);
    engine.state.success.install('add', Mods['add-success'](engine, chance));
    if (engine.successor(chance)) {
      remaining = engine.state.target.progress() - engine.state.progress();
      progress = Math.floor(remaining / 3.0);
      engine.state.progress.install('add', Mods['add-progress'](engine, progress));
      engine.state.capacity.install('use', Mods['use-capacity'](engine));
      return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
    }
  });

  Skills['piece-by-piece'].init(15, {
    success: 0.9
  });

  Skills['manipulation'] = new Skill('manipulation', function(engine) {
    var buff;
    buff = new Buff('manipulation');
    buff.init(this.state.rounds);
    buff.on('tick', function(engine) {
      return engine.state.capacity.install('add', Mods['add-capacity'](engine, this.state.bonus));
    });
    engine.add_buff(buff);
    return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
  });

  Skills['manipulation'].init(88, {
    rounds: 3,
    bonus: 10
  });

  Skills['flawless-synthesis'] = new Skill('flawless-synthesis', function(engine) {
    var chance, progress;
    chance = Math.min(1.0, engine.values.success() + this.state.success);
    engine.state.success.install('add', Mods['add-success'](engine, chance));
    if (engine.successor(chance)) {
      progress = this.state.bonus;
      engine.state.progress.install('add', Mods['add-progress'](engine, progress));
      engine.state.capacity.install('use', Mods['use-capacity'](engine));
      return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
    }
  });

  Skills['flawless-synthesis'].init(15, {
    success: 0.9,
    bonus: 40
  });

  Skills['innovation'] = new Skill('innovation', function(engine) {
    var buff;
    buff = new Buff('innovation');
    buff.init(this.state.rounds);
    buff.install(engine.state.control, function(akk) {
      return akk + Math.floor(0.5 * engine.state.control.base);
    });
    engine.add_buff(buff);
    return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
  });

  Skills['innovation'].init(18, {
    rounds: 3
  });

  Skills['waste-not'] = new Skill('waste-not', function(engine) {
    var buff;
    buff = new Buff('waste-not');
    buff.init(this.state.rounds, {}, 'waste-not-ii');
    buff.install(engine.values.capacity, function(akk) {
      return Math.floor(akk * 0.5);
    });
    engine.add_buff(buff);
    return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
  });

  Skills['waste-not'].init(56, {
    rounds: 4
  });

  Skills['brand-of-earth'] = new Skill('brand-of-earth', function(engine) {
    var chance, progress;
    chance = Math.min(1.0, engine.values.success() + this.state.success);
    engine.state.success.install('add', Mods['add-success'](engine, chance));
    if (engine.successor(chance)) {
      progress = engine.values.progress() * this.state.efficiency;
      if (engine.state.target.affinity() === this.state.affinity) {
        progress = progress * 2.0;
      }
      engine.state.progress.install('add', Mods['add-progress'](engine, progress));
      engine.state.capacity.install('use', Mods['use-capacity'](engine));
      return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
    }
  });

  Skills['brand-of-earth'].init(15, {
    success: 0.9,
    affinity: 'earth',
    efficiency: 1.0
  });

  Skills['waste-not-ii'] = new Skill('waste-not-ii', function(engine) {
    var buff;
    buff = new Buff('waste-not-ii');
    buff.init(this.state.rounds, {}, 'waste-not');
    buff.install(engine.values.capacity, function(akk) {
      return Math.floor(akk * 0.5);
    });
    engine.add_buff(buff);
    return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
  });

  Skills['waste-not-ii'].init(98, {
    rounds: 8
  });

  Skills['careful-synthesis'] = new Skill('careful-synthesis', function(engine) {
    var progress;
    progress = engine.values.progress() * this.state.efficiency;
    engine.state.progress.install('add', Mods['add-progress'](engine, progress));
    return engine.state.capacity.install('use', Mods['use-capacity'](engine));
  });

  Skills['careful-synthesis'].init(0, {
    success: 1.0,
    efficiency: 0.9
  });

  Skills['brand-of-lightning'] = new Skill('brand-of-ligthning', function(engine) {
    var chance, progress;
    chance = Math.min(1.0, engine.values.success() + this.state.success);
    engine.state.success.install('add', Mods['add-success'](engine, chance));
    if (engine.successor(chance)) {
      progress = engine.values.progress() * this.state.efficiency;
      if (engine.state.target.affinity() === this.state.affinity) {
        progress = progress * 2.0;
      }
      engine.state.progress.install('add', Mods['add-progress'](engine, progress));
      engine.state.capacity.install('use', Mods['use-capacity'](engine));
      return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
    }
  });

  Skills['brand-of-lightning'].init(15, {
    success: 0.9,
    affinity: 'lightning',
    efficiency: 1.0
  });

  Skills['careful-synthesis-ii'] = new Skill('careful-synthesis-ii', function(engine) {
    var progress;
    progress = engine.values.progress() * this.state.efficiency;
    engine.state.progress.install('add', Mods['add-progress'](engine, progress));
    return engine.state.capacity.install('use', Mods['use-capacity'](engine));
  });

  Skills['careful-synthesis-ii'].init(0, {
    success: 1.0,
    efficiency: 1.2
  });

  Skills['tricks-of-the-trade'] = new Skill('tricks-of-the-trade', function(engine) {
    var cp;
    cp = this.state.bonus;
    return engine.state.cp.install('add', Mods['add-cp'](engine, cp));
  });

  Skills['tricks-of-the-trade'].init(0, {
    bonus: 20
  });

  Skills['brand-of-water'] = new Skill('brand-of-water', function(engine) {
    var chance, progress;
    chance = Math.min(1.0, engine.values.success() + this.state.success);
    engine.state.success.install('add', Mods['add-success'](engine, chance));
    if (engine.successor(chance)) {
      progress = engine.values.progress() * this.state.efficiency;
      if (engine.state.target.affinity() === this.state.affinity) {
        progress = progress * 2.0;
      }
      engine.state.progress.install('add', Mods['add-progress'](engine, progress));
      engine.state.capacity.install('use', Mods['use-capacity'](engine));
      return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
    }
  });

  Skills['brand-of-water'].init(15, {
    success: 0.9,
    affinity: 'water',
    efficiency: 1.0
  });

  Skills['comfort-zone'] = new Skill('comfort-zone', function(engine) {
    var buff, cp;
    buff = new Buff('comfort-zone');
    buff.init(this.state.rounds);
    cp = this.state.bonus;
    buff.on('tick', function(engine) {
      return engine.state.cp.install('add', Mods['add-cp'](engine, cp));
    });
    engine.add_buff(buff);
    return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
  });

  Skills['comfort-zone'].init(66, {
    rounds: 10,
    bonus: 8
  });

  Skills['hasty-touch'] = new Skill('hasty-touch', function(engine) {
    var chance, quality;
    chance = Math.min(1.0, engine.values.success() + this.state.success);
    engine.state.success.install('add', Mods['add-success'](engine, chance));
    if (engine.successor(chance)) {
      quality = engine.values.quality() * this.state.efficiency;
      engine.state.quality.install('add', Mods['add-quality'](engine, quality));
      engine.state.capacity.install('use', Mods['use-capacity'](engine));
      return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
    }
  });

  Skills['hasty-touch'].init(0, {
    success: 0.5,
    efficiency: 1.0
  });

  Skills['steady-hand-ii'] = new Skill('steady-hand-ii', function(engine) {
    var bonus, buff;
    bonus = this.state.bonus;
    buff = new Buff('steady-hand-ii');
    buff.init(this.state.rounds, {}, 'steady-hand');
    buff.install(engine.values.success, function(akk) {
      return akk + bonus;
    });
    engine.add_buff(buff);
    return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
  });

  Skills['steady-hand-ii'].init(25, {
    bonus: 0.3,
    rounds: 5
  });

  Skills['reclaim'] = new Skill('reclaim', function(engine) {
    var buff;
    buff = new Buff('reclaim');
    buff.init('infinite');
    engine.add_buff(buff);
    return engine.state.cp.install('sub', Mods['sub-cp'](engine, this.cost));
  });

  Skills['reclaim'].init(55);


  /*
    Buffs with special state:
      'inner_quite'
        state:
          - size: Stack Counter
   */

}).call(this);
