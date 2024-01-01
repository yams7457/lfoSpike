m = midi.connect()

_lfos = require 'lfo'

heldNotes = {}

pentad = {0, 2, 4, 7, 9, 12, 
         14, 16, 19, 21, 24, 26, 
         28, 31, 33, 36, 38, 40}

  params:add{
    type = "control",
    id = "melCycle",
    name = "melCycle",
    controlspec = controlspec.def{
      min = .01,
      max = 45,
      warp = 'lin',
      step = 0.01, -- allows decimal increments
      default = math.random(1,23),
      units = 's'
    }
  }

  params:add{
    type = "control",
    id = "melRatio",
    name = "melRatio",
    controlspec = controlspec.def{
      min = 1,
      max = 99,
      warp = 'lin',
      step = 1, -- allows decimal increments
      default = math.random(1,99)
    }
  }


  params:add{
    type = "control",
    id = "melMin",
    name = "melMin",
    controlspec = controlspec.def{
      min = 1,
      max = 18,
      warp = 'lin',
      default = math.random(2,18)
    }
  }

  params:add{
    type = "control",
    id = "melRange",
    name = "melRange",
    controlspec = controlspec.def{
      min = 1,
      max = 18,
      warp = 'lin',
      default = math.random(2,18)
    }
  }


params:add_number(
    "melSustain", -- id
    "melody sustain", -- name
    1, -- min
    64, -- max
    1, -- default
    false -- wrap
    )

    params:add{
        type = "control",
        id = "compCycle",
        name = "compCycle",
        controlspec = controlspec.def{
          min = .01,
          max = 45,
          warp = 'lin',
          step = 0.01, -- allows decimal increments
          default = math.random(1,23),
          units = 's'
        }
      }
    
      params:add{
        type = "control",
        id = "compRatio",
        name = "compRatio",
        controlspec = controlspec.def{
          min = 1,
          max = 99,
          warp = 'lin',
          step = 1, -- allows decimal increments
          default = math.random(1,99)
        }
      }
    
    
      params:add{
        type = "control",
        id = "compMin",
        name = "compMin",
        controlspec = controlspec.def{
          min = 1,
          max = 18,
          warp = 'lin',
          default = math.random(2,18)
        }
      }
    
      params:add{
        type = "control",
        id = "compRange",
        name = "compRange",
        controlspec = controlspec.def{
          min = 1,
          max = 18,
          warp = 'lin',
          default = math.random(2,18)
        }
      }

      params:add_number(
        "compSustain", -- id
        "comp sustain", -- name
        1, -- min
        64, -- max
        1, -- default
        false -- wrap
        )

      params:add{
        type = "control",
        id = "bassCycle",
        name = "bassCycle",
        controlspec = controlspec.def{
          min = .01,
          max = 45,
          warp = 'lin',
          step = 0.01, -- allows decimal increments
          default = math.random(1,23),
          units = 's'
        }
      }
    
      params:add{
        type = "control",
        id = "bassRatio",
        name = "bassRatio",
        controlspec = controlspec.def{
          min = 1,
          max = 99,
          warp = 'lin',
          step = 1, -- allows decimal increments
          default = math.random(1,99)
        }
      }
    
    
      params:add{
        type = "control",
        id = "bassMin",
        name = "bassMin",
        controlspec = controlspec.def{
          min = 1,
          max = 18,
          warp = 'lin',
          default = math.random(2,18)
        }
      }
    
      params:add{
        type = "control",
        id = "bassRange",
        name = "bassRange",
        controlspec = controlspec.def{
          min = 1,
          max = 18,
          warp = 'lin',
          default = math.random(2,18)
        }
      }

      params:add_number(
        "bassSustain", -- id
        "bass sustain", -- name
        1, -- min
        64, -- max
        1, -- default
        false -- wrap
        )

function init()
    createLFOs()
    params:set_action("melRange", function() melLfo:set('max', math.floor(math.min(18, params:get('melRange') + params:get('melMin')))) end)
    params:set_action("melMin", function() melLfo:set('max', math.floor(math.min(18, params:get('melRange') + params:get('melMin')))) melLfo:set('min', params:get('melMin')) end)
    params:set('melMin', math.random(1,15))
    params:set('melRange', math.random(2,18 - params:get('melMin')))
    params:set_action("compRange", function() compLfo:set('max', math.floor(math.min(18, params:get('compRange') + params:get('compMin')))) end)
    params:set_action("compMin", function() compLfo:set('max', math.floor(math.min(18, params:get('compRange') + params:get('compMin')))) compLfo:set('min', params:get('compMin')) end)
    params:set('compMin', math.random(1,15))
    params:set('compRange', math.random(2,18 - params:get('compMin')))
    params:set_action("bassRange", function() bassLfo:set('max', math.floor(math.min(18, params:get('bassRange') + params:get('bassMin')))) end)
    params:set_action("bassMin", function() bassLfo:set('max', math.floor(math.min(18, params:get('bassRange') + params:get('bassMin')))) bassLfo:set('min', params:get('bassMin')) end)
    params:set('bassMin', math.random(1,15))
    params:set('bassRange', math.random(2,18 - params:get('bassMin')))
    for i = 1,16 do
        m:cc(123, 0, i)
    end
end

function createLFOs()
    melLfo = _lfos.new(
        'tri', -- shape will default to 'sine'
        0, -- min
        18, -- max
        1, -- depth will default to 1
        'free', -- mode
        2.4, -- period (in 'free' mode, represents seconds)
      function(scaled, raw) melPoll(math.ceil(scaled), raw) end -- action, always passes scaled and raw values
    )

     melLfo:start() -- start our LFO, complements ':stop()'

     compLfo = _lfos.new(
        'tri', -- shape will default to 'sine'
        0, -- min
        18, -- max
        1, -- depth will default to 1
        'free', -- mode
        2.4, -- period (in 'free' mode, represents seconds)
      function(scaled, raw) compPoll(math.ceil(scaled), raw) end -- action, always passes scaled and raw values
    )

     compLfo:start() -- start our LFO, complements ':stop()'

     bassLfo = _lfos.new(
        'tri', -- shape will default to 'sine'
        0, -- min
        18, -- max
        1, -- depth will default to 1
        'free', -- mode
        2.4, -- period (in 'free' mode, represents seconds)
      function(scaled, raw) bassPoll(math.ceil(scaled), raw) end -- action, always passes scaled and raw values
    )

     bassLfo:start() -- start our LFO, complements ':stop()'
end


function melPoll(scaled, raw)
    if scaled >= 18 then
        melLfo:set('period', params:get('melCycle') * params:get('melRatio') / 100)
    elseif scaled <= 1 then
        melLfo:set('period', params:get('melCycle') * (100 - params:get('melRatio')) / 100)
    end
    if lastMelodyIndex ~= scaled then
        lastMelodyIndex = scaled
        m:note_on(pentad[scaled] + 60, math.random(60, 127), 1)
        releaseTimer(pentad[scaled] + 60, 1)
    end
end

function compPoll(scaled, raw)
    if scaled >= 18 then
        compLfo:set('period', params:get('compCycle') * params:get('compRatio') / 100)
    elseif scaled <= 1 then
        compLfo:set('period', params:get('compCycle') * (100 - params:get('compRatio')) / 100)
    end
    if lastMelodyIndex ~= scaled then
        lastMelodyIndex = scaled
        m:note_on(pentad[scaled] + 48, math.random(60, 127), 2)
        releaseTimer(pentad[scaled] + 48, 2)
    end
  end

  function bassPoll(scaled, raw)
    if scaled >= 18 then
        bassLfo:set('period', params:get('bassCycle') * params:get('bassRatio') / 100)
    elseif scaled <= 1 then
        bassLfo:set('period', params:get('bassCycle') * (100 - params:get('bassRatio')) / 100)
    end
    if lastMelodyIndex ~= scaled then
        lastMelodyIndex = scaled
        m:note_on(pentad[scaled] + 36, math.random(60, 127), 3)
        releaseTimer(pentad[scaled] + 36, 3)
    end
  end

function releaseTimer(pitch, ch)
    local sustain = 1
    if ch == 1 then
        sustain = params:get('melSustain')
    elseif ch == 2 then
        sustain = params:get('compSustain')
    elseif ch == 3 then
        sustain = params:get('bassSustain')
    end
    clock.run(function()
        -- Wait for two seconds
        clock.sync(sustain)
        m:note_off(pitch, 0, ch)
      end)
end
