local hotkey = require('hs.hotkey')
local eventtap = require('hs.eventtap')
local fn = require('hs.fnutils')

local module = {
  name = 'SideModifiers',
  version = '0.1',
  author = 'Michał Ciebiada',
  homepage = 'https://github.com/ciebiada/SideModifiers.spoon',
  license = 'MIT - https://opensource.org/licenses/MIT'
}

local suppressLogging = function(fn)
  local prevLogLevel = hotkey.getLogLevel()
  hotkey.setLogLevel('warning')
  fn()
  hotkey.setLogLevel(prevLogLevel)
end

local bindings = {}

local mods = {
  { name = 'left_shift', flag = eventtap.event.rawFlagMasks.deviceLeftShift },
  { name = 'left_control', flag = eventtap.event.rawFlagMasks.deviceLeftControl },
  { name = 'left_option', flag = eventtap.event.rawFlagMasks.deviceLeftAlternate },
  { name = 'left_command', flag = eventtap.event.rawFlagMasks.deviceLeftCommand },
  { name = 'right_shift', flag = eventtap.event.rawFlagMasks.deviceRightShift },
  { name = 'right_control', flag = eventtap.event.rawFlagMasks.deviceRightControl },
  { name = 'right_option', flag = eventtap.event.rawFlagMasks.deviceRightAlternate },
  { name = 'right_command', flag = eventtap.event.rawFlagMasks.deviceRightCommand }
}

module.start = function()
  -- monkey patch bind
  local orgBind = hotkey.bind
  hotkey.bind = function(...)
    local hk = orgBind(...)

    local args = {...}

    local flags = 0

    fn.each(args[1], function(userString)
      fn.each(mods, function(mod)
        if userString == mod.name then
          flags = flags | mod.flag
        end
      end)
    end)

    if flags > 0 then
      table.insert(bindings, {hk = hk, flags = flags})
    end
  end

  -- enable / disable bindings based on flags pressed
  module.et = eventtap.new({ eventtap.event.types.flagsChanged }, function(e)
    local flags = e:rawFlags()

    suppressLogging(function()
      fn.each(bindings, function(binding)
        if flags & binding.flags == binding.flags then
          binding.hk:enable()
        else
          binding.hk:disable()
        end
      end)
    end)
  end):start()

  return module
end

module.stop = function()
  if module.et then
    module.et:stop()
  end

  return module
end

return module
