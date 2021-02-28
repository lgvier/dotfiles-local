local module = {}
local log = hs.logger.new('yabai_extras','debug')

-- spaces management
-- (yabai space management doesnt work well with SIP enabled)

-- https://github.com/asmagill/hs._asm.undocumented.spaces
local spaces = require("hs._asm.undocumented.spaces")

local ext_screen = require("ext.screen")
local ext_utils = require("ext.utils")

local getAllSpaceIds = function()
  -- invoke yabai to get the spaces in the correct order
  local cmdResult = ext_utils.capture(hostConfig.binPath .. "/yabai -m query --spaces | " .. hostConfig.binPath .. "/jq '.[] | .id'")
  local result = {}
  local spaceCnt = 0
  for line in string.gmatch(cmdResult,'[^\r\n]+') do
    spaceCnt = spaceCnt + 1
    -- log.d('getAllSpaceIds result[', spaceCnt, ']=', line)
    result[spaceCnt] = tonumber(line)
  end
  -- reorder spaces if needed
  -- mac spaces are sometimes incorrectly ordered when using multiple monitors
  if hostConfig then
    local spaceMappings = hostConfig['spaceNumberMappings']
    if spaceMappings then
      log.d('spaceMappings found')
      table.sort(result, function(a,b)
        local am = spaceMappings[a] or a 
        local bm = spaceMappings[b] or b
        -- log.d('am', am, 'bm', bm)
        return am > bm 
      end)
    end
  end
  -- cache for rendering the menu bar
  module.spaceIds = result
  --
  log.d('getAllSpaceIds spaceCnt: ', spaceCnt)
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
      ext_screen.focusScreen(screen)
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

local moveToSpace = function(space, goToNewSpace)
  if space then
    local win = hs.window.focusedWindow()
    local screen = findSpaceScreen(space)
    log.i("moveToSpace(", space, ") screen#: ", screen)
    win:spacesMoveTo(space)
    local f = win:frame()
    local sf = screen:frame()
    log.i("win frame after moving window: ", f, ", screen frame: ", sf)
    if (f.x > sf.w or f.y > sf.h) then
      log.i("moving window into visible screen frame")
      if (f.x > sf.w) then
        f.x = sf.w - f.w
      end
      if (f.y > sf.h) then
        f.y = sf.h - f.h
      end
      win:setFrame(f)
    end
    if goToNewSpace then
      spaces.changeToSpace(space)
      win:focus()
    else
      ext_screen.focusScreen(screen)
    end
  end
end

local goBackToPreviousSpace = function()
  log.i("goBackToPreviousSpace spaceHistPrev", module.spaceHistPrev)
  if module.spaceHistPrev then
    goToSpace(module.spaceHistPrev)
  end
end

local moveBackToPreviousSpace = function(goToNewSpace)
  log.i("moveBackToPreviousSpace spaceHistPrev", module.spaceHistPrev)
  if module.spaceHistPrev then
    moveToSpace(module.spaceHistPrev, goToNewSpace)
  end
end

local goToNextSpace = function(fwd)
  local space = findNextSpace(fwd)
  log.i('goToNextSpace - next space fwd?', fwd, ':', space)
  goToSpace(space)
end

local moveToNextSpace = function(fwd, goToNewSpace)
  local space = findNextSpace(fwd)
  log.i('moveToNextSpace - next space fwd?', fwd, ':', space)
  moveToSpace(space, goToNewSpace)
end

local goToSpaceN = function(n)
  local spaceIds = getAllSpaceIds()
  local space = spaceIds[n]
  local currSpace = spaces.activeSpace()
  log.i("goToSpaceN(", n, ") space id: ", space, ", currSpace", currSpace)
  if space ~= currSpace then
    goToSpace(space)
  else
    goBackToPreviousSpace()
  end
end

local moveToSpaceN = function(n, goToNewSpace)
  local spaceIds = getAllSpaceIds()
  local space = spaceIds[n]
  local currSpace = spaces.activeSpace()
  log.i("moveToSpaceN(", n, ") space id: ", space, ", currSpace", currSpace)
  if space ~= currSpace then
    moveToSpace(space, goToNewSpace)
  else
    moveBackToPreviousSpace(goToNewSpace)
  end
end

local function reload_yabai()
  -- FIXME
  local result = os.execute(hostConfig.binPath .. "/brew services restart koekeishiya/formulae/yabai");
  log.i(result and "yabai restarted" or "yabai restart failed")
end
local function reload_skhdrc()
  local result = os.execute(hostConfig.binPath .. "/skhd --reload");
  log.i(result and "skhd config reloaded" or "skhd config reload failed")
end
local function reload_limelight()
  local result = os.execute(os.getenv("HOME") .. "/.bin/yabai/limelight.sh");
  log.i(result and "limelight reloaded" or "limelight reload failed")
end

local function updateMenuBar()
  if not module.spaceIds then
    getAllSpaceIds()
  end
  local currSpace = spaces.activeSpace()

  local t = { }
  local spaceCnt = 0
  for k, v in pairs(module.spaceIds) do
    spaceCnt = spaceCnt + 1
    if v == currSpace then
      t[#t+1] = "["
    end
    t[#t+1] = tostring(spaceCnt)
    if v == currSpace then
      t[#t+1] = "]"
    end
  end

  module.menubar:setTitle(table.concat(t))
end

local function initMenuBar()
  module.menubar = hs.menubar.new()
  module.menubar:setMenu(
    {
      { title = "Reload yabai", fn = reload_yabai },
      { title = "Reload skhd", fn = reload_skhdrc },
      { title = "Reload limelight", fn = reload_limelight },
      -- { title = "-" },
    })
  updateMenuBar()
end

module.start = function()
  initMenuBar()

  hs.hotkey.bind('alt', '[', function() goToNextSpace(false) end)
  hs.hotkey.bind('alt', ']', function() goToNextSpace(true) end)
  hs.hotkey.bind('alt', 'b', function() goBackToPreviousSpace() end)
  hs.hotkey.bind(atsh, '[', function() moveToNextSpace(false, true) end)
  hs.hotkey.bind(atsh, ']', function() moveToNextSpace(true, true) end)
  hs.hotkey.bind(atsh, 'b', function() moveBackToPreviousSpace(true) end)
  hs.hotkey.bind(ctsh, '[', function() moveToNextSpace(false, false) end)
  hs.hotkey.bind(ctsh, ']', function() moveToNextSpace(true, false) end)
  hs.hotkey.bind(ctsh, 'b', function() moveBackToPreviousSpace(false) end)

  hs.hotkey.bind('alt', '1', function() goToSpaceN(1) end)
  hs.hotkey.bind('alt', '2', function() goToSpaceN(2) end)
  hs.hotkey.bind('alt', '3', function() goToSpaceN(3) end)
  hs.hotkey.bind('alt', '4', function() goToSpaceN(4) end)
  hs.hotkey.bind('alt', '5', function() goToSpaceN(5) end)
  hs.hotkey.bind('alt', '6', function() goToSpaceN(6) end)
  hs.hotkey.bind(atsh, '1', function() moveToSpaceN(1, true) end)
  hs.hotkey.bind(atsh, '2', function() moveToSpaceN(2, true) end)
  hs.hotkey.bind(atsh, '3', function() moveToSpaceN(3, true) end)
  hs.hotkey.bind(atsh, '4', function() moveToSpaceN(4, true) end)
  hs.hotkey.bind(atsh, '5', function() moveToSpaceN(5, true) end)
  hs.hotkey.bind(atsh, '6', function() moveToSpaceN(6, true) end)
  hs.hotkey.bind(ctsh, '1', function() moveToSpaceN(1, false) end)
  hs.hotkey.bind(ctsh, '2', function() moveToSpaceN(2, false) end)
  hs.hotkey.bind(ctsh, '3', function() moveToSpaceN(3, false) end)
  hs.hotkey.bind(ctsh, '4', function() moveToSpaceN(4, false) end)
  hs.hotkey.bind(ctsh, '5', function() moveToSpaceN(5, false) end)
  hs.hotkey.bind(ctsh, '6', function() moveToSpaceN(6, false) end)

  -- hs.pathwatcher.new(os.getenv("HOME") .. "/dotfiles-local/yabairc", reload_yabai):start()
  -- hs.hotkey.bind('alt', 'y', reload_yabai)
  -- hs.pathwatcher.new(os.getenv("HOME") .. "/dotfiles-local/skhdrc", reload_skhdrc):start()

  log.i("yabai_extras module started.")
end

module.stop = function()
  if module.menubar then
    module.menubar:delete()
  end
end

module.on_space_event = function()
  -- log.i("on_space_event")
  local currSpace = spaces.activeSpace()
  if currSpace ~= module.spaceHistCurr then
    module.spaceHistPrev = module.spaceHistCurr
    module.spaceHistCurr = currSpace
    updateMenuBar()
    log.i("on_space_event: spaceHistPrev", module.spaceHistPrev, ", spaceHistCurr", module.spaceHistCurr)
  end
end

return module
