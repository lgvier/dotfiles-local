local module = {}
local log = hs.logger.new('yabai_extras','debug')

-- spaces management
-- (yabai space management doesnt work well with SIP enabled)

-- https://github.com/asmagill/hs._asm.undocumented.spaces
local spaces = require("hs._asm.undocumented.spaces")

local screen_ext = require("ext.screen")

local findNextSpace = function(fwd)
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
  if fwd then 
    if spaceIdx == spaceCnt then 
      return screenSpaces[1]
    else
      return screenSpaces[spaceIdx + 1]
    end
  else
    if spaceIdx == 1 then 
      return screenSpaces[spaceCnt]
    else
      return screenSpaces[spaceIdx - 1]
    end
  end
end

local goToSpace = function(fwd)
  local nextSpace = findNextSpace(fwd)
  log.i("goToSpace: ", nextSpace)
  spaces.changeToSpace(nextSpace)
end

local moveToSpace = function(fwd)
  local win = hs.window.focusedWindow()
  local nextSpace = findNextSpace(false)
  log.i("moveToSpace: ", nextSpace)
  win:spacesMoveTo(nextSpace)
  spaces.changeToSpace(nextSpace)
  win:focus()
end

local findSpaceN = function(n)
  local screens = hs.screen.allScreens()
  local spaceCnt = 0
  for _, screen in pairs(screens) do
    local screenSpaces = screen:spaces()
    for k, v in pairs(screenSpaces) do
      -- log.i('space [', k, ']', v)
      spaceCnt = spaceCnt + 1
      if spaceCnt == n then
        return screen, v
      end
    end
  end
end

local goToSpaceN = function(n)
  local screen, space = findSpaceN(n)
  log.i("goToSpaceN(", n, ") space#: ", space)
  if space then
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

local moveToSpaceN = function(n)
  local win = hs.window.focusedWindow()
  local screen, space = findSpaceN(n)
  log.i("moveToSpaceN(", n, ") space#: ", space)
  if space then
    win:spacesMoveTo(space)
    spaces.changeToSpace(space)
    win:focus()
  end
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
  hs.hotkey.bind('alt', '[', function() goToSpace(false) end)
  hs.hotkey.bind('alt', ']', function() goToSpace(true) end)
  hs.hotkey.bind('alt', '1', function() goToSpaceN(1) end)
  hs.hotkey.bind('alt', '2', function() goToSpaceN(2) end)
  hs.hotkey.bind('alt', '3', function() goToSpaceN(3) end)
  hs.hotkey.bind('alt', '4', function() goToSpaceN(4) end)
  hs.hotkey.bind(atsh, '[', function() moveToSpace(false) end)
  hs.hotkey.bind(atsh, ']', function() moveToSpace(true) end)
  hs.hotkey.bind(atsh, '1', function() moveToSpaceN(1) end)
  hs.hotkey.bind(atsh, '2', function() moveToSpaceN(2) end)
  hs.hotkey.bind(atsh, '3', function() moveToSpaceN(3) end)
  hs.hotkey.bind(atsh, '4', function() moveToSpaceN(4) end)
  
  -- hs.pathwatcher.new(os.getenv("HOME") .. "/dotfiles-local/yabairc", reload_yabai):start()
  hs.hotkey.bind(mash, 'y', reload_yabai)
  hs.pathwatcher.new(os.getenv("HOME") .. "/dotfiles-local/skhdrc", reload_skhdrc):start()
  log.i("yabai_extras module started")
end

module.stop = function()

end

return module
