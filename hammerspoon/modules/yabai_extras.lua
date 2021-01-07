local module = {}
local log = hs.logger.new('yabai_extras','debug')

-- spaces management
-- (yabai space management doesnt work well with SIP enabled)

-- https://github.com/asmagill/hs._asm.undocumented.spaces
local spaces = require("hs._asm.undocumented.spaces")

local screen_ext = require("ext.screen")

local getAllSpaceIds = function()
  -- invoke yabai to get the spaces in the correct order
  local handle = io.popen("/usr/local/bin/yabai -m query --spaces | /usr/local/bin/jq '.[] | .id'")
  local cmdResult = handle:read("*a")
  handle:close()
  local result = {}
  local spaceCnt = 0
  for line in string.gmatch(cmdResult,'[^\r\n]+') do
    spaceCnt = spaceCnt + 1
    log.d('getAllSpaceIds result[', spaceCnt, ']=', line)
    result[spaceCnt] = tonumber(line)
  end
  return result
end

local findSpaceScreen = function(space)
  local screenId = spaces.spaceScreenUUID(space)
  local screens = hs.screen.allScreens()
  for sk, screen in pairs(screens) do
    if screen:spacesUUID() == screenId then
      log.d('findSpaceScreen space:', space, 'screen', screen)
      return screen, space
    end
  end
end

local findNextSpace = function(fwd)
  local currSpace = spaces.activeSpace()
  log.d('findNextSpace fwd?', fwd, 'currSpace:', currSpace)
  local spaceIds = getAllSpaceIds()
  local spaceCnt = 0
  local spaceIdx = 0
  for k, v in pairs(spaceIds) do
    spaceCnt = spaceCnt + 1
    if v == currSpace then
      spaceIdx = k
    end
  end
  if fwd then 
    if spaceIdx == spaceCnt then 
      return spaceIds[1]
    else
      return spaceIds[spaceIdx + 1]
    end
  else
    if spaceIdx == 1 then 
      return spaceIds[spaceCnt]
    else
      return spaceIds[spaceIdx - 1]
    end
  end
end

local goToSpace = function(space)
  if space then
    local screen = findSpaceScreen(space)
    log.i("goToSpace(", space, ") screen#: ", screen)
    if screen ~= hs.screen.mainScreen() then
      log.i('changing focus to screen', screen)
      screen_ext.focusScreen(screen)
    end
    local currSpace = spaces.activeSpace()
    if space ~= currSpace then
      log.i('changing to space', space)
      spaces.changeToSpace(space)
    else
      log.i('space already visible')
    end
  end
end

local moveToSpace = function(space)
  if space then
    local win = hs.window.focusedWindow()
    local screen = findSpaceScreen(space)
    log.i("moveToSpace(", space, ") screen#: ", screen)
    win:spacesMoveTo(space)
    spaces.changeToSpace(space)
    win:focus()
  end
end

local goToNextSpace = function(fwd)
  local space = findNextSpace(fwd)
  log.i('goToNextSpace - next space fwd?', fwd, ':', space)
  goToSpace(space)
end

local moveToNextSpace = function(fwd)
  local space = findNextSpace(fwd)
  log.i('moveToNextSpace - next space fwd?', fwd, ':', space)
  moveToSpace(space)
end

local goToSpaceN = function(n)
  local spaceIds = getAllSpaceIds()
  local space = spaceIds[n]
  log.i("goToSpaceN(", n, ") space#: ", space)
  goToSpace(space)
end

local moveToSpaceN = function(n)
  local spaceIds = getAllSpaceIds()
  local space = spaceIds[n]
  log.i("moveToSpaceN(", n, ") space#: ", space)
  moveToSpace(space)
end

local function reload_yabai()
  local result = os.execute("/usr/local/bin/brew services restart koekeishiya/formulae/yabai");
  log.i(result and "yabai restarted" or "yabai restart failed")
end
local function reload_skhdrc()
  local result = os.execute("/usr/local/bin/skhd --reload");
  log.i(result and "skhd config reloaded" or "skhd config reload failed")
end

module.start = function()
  hs.hotkey.bind('alt', '[', function() goToNextSpace(false) end)
  hs.hotkey.bind('alt', ']', function() goToNextSpace(true) end)
  hs.hotkey.bind(atsh, '[', function() moveToNextSpace(false) end)
  hs.hotkey.bind(atsh, ']', function() moveToNextSpace(true) end)

  hs.hotkey.bind('alt', '1', function() goToSpaceN(1) end)
  hs.hotkey.bind('alt', '2', function() goToSpaceN(2) end)
  hs.hotkey.bind('alt', '3', function() goToSpaceN(3) end)
  hs.hotkey.bind('alt', '4', function() goToSpaceN(4) end)
  hs.hotkey.bind('alt', '5', function() goToSpaceN(5) end)
  hs.hotkey.bind('alt', '6', function() goToSpaceN(6) end)
  hs.hotkey.bind(atsh, '1', function() moveToSpaceN(1) end)
  hs.hotkey.bind(atsh, '2', function() moveToSpaceN(2) end)
  hs.hotkey.bind(atsh, '3', function() moveToSpaceN(3) end)
  hs.hotkey.bind(atsh, '4', function() moveToSpaceN(4) end)
  hs.hotkey.bind(atsh, '5', function() moveToSpaceN(5) end)
  hs.hotkey.bind(atsh, '6', function() moveToSpaceN(6) end)

  -- hs.pathwatcher.new(os.getenv("HOME") .. "/dotfiles-local/yabairc", reload_yabai):start()
  hs.hotkey.bind('alt', 'y', reload_yabai)
  hs.pathwatcher.new(os.getenv("HOME") .. "/dotfiles-local/skhdrc", reload_skhdrc):start()
  log.i("yabai_extras module started")
end

module.stop = function()

end

return module
