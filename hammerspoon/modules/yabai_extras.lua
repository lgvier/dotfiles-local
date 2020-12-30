local module = {}

local log = hs.logger.new('yabai_extras','debug')

-- https://github.com/asmagill/hs._asm.undocumented.spaces
local spaces = require("hs._asm.undocumented.spaces")

-- spaces management
-- (yabai space management doesnt work well with SIP enabled)
local findNextSpace = function(back)
  local currSpace = spaces.activeSpace()
  local screenSpaces = hs.window.focusedWindow():screen():spaces()
  local spaceCnt = 0
  local spaceIdx = 0
  for k, v in pairs(screenSpaces) do
    spaceCnt = spaceCnt + 1
    if v == currSpace then
      spaceIdx = k
    end
  end
  if back then 
    if spaceIdx == 1 then 
      return screenSpaces[spaceCnt]
    else
      return screenSpaces[spaceIdx - 1]
    end
  else
    if spaceIdx == spaceCnt then 
      return screenSpaces[1]
    else
      return screenSpaces[spaceIdx + 1]
    end
  end
end

local goToSpace = function(back)
  local nextSpace = findNextSpace(back)
  -- hs.alert.show("space [" .. nextSpace .. "] ")
  spaces.changeToSpace(nextSpace)
end

local moveToSpace = function(back)
  local win = hs.window.focusedWindow()
  local nextSpace = findNextSpace(false)
  -- hs.alert.show("space [" .. nextSpace .. "] ")
  win:spacesMoveTo(nextSpace)
  spaces.changeToSpace(nextSpace)
  win:focus()
end

module.start = function()
  hs.hotkey.bind(ctcm, '-', function() goToSpace(true) end)
  hs.hotkey.bind(mash, '-', function() goToSpace(false) end)
  hs.hotkey.bind(ctcm, '=', function() moveToSpace(true) end)
  hs.hotkey.bind(mash, '=', function() moveToSpace(false) end)
  log.i("yabai_extras module started")
end

module.stop = function()

end

return module
