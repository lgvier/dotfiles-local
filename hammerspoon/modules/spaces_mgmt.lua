local module = {}
local log = hs.logger.new('spaces_mgmt','debug')

-- spaces management
-- (yabai space management doesnt work well with SIP enabled)

-- https://github.com/asmagill/hs._asm.undocumented.spaces
local spaces = require("hs._asm.undocumented.spaces")
local timer = require("hs.timer")

local ext_screen = require("ext.screen")
local ext_utils = require("ext.utils")

local getAllSpaceIds = function()
  -- get the correct screen order to fix the spaces result
  local screens = hs.screen.allScreens()
  local screen_num = {}
  for sk, s in pairs(screens) do
    screen_num[s:getUUID()] = sk
  end
  -- get all the spaces, sorted by screen_num
  local result = {}
  local layout = spaces.layout()
  for sk, s in ext_utils.spairs(layout, function(t, a, b) return screen_num[a] < screen_num[b] end) do
    for ssk, ss in pairs(s) do
      result[#result + 1] = ss
    end
  end
  -- cache for rendering the menu bar
  module.spaceIds = result
  log.d('getAllSpaceIds spaceCnt: ', #result)
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
      -- { title = "Title", fn = some_function },
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

  module.screenWatcher = hs.screen.watcher.newWithActiveScreen(module.on_space_event)
  module.screenWatcher:start()
  module.spaceWatcher = hs.spaces.watcher.new(module.on_space_event)
  module.spaceWatcher:start()

  log.i("spaces_mgmt module started.")
end

module.stop = function()
  if module.menubar then
    module.menubar:delete()
  end
  if module.screenWatcher then
    module.screenWatcher:stop()
  end
  if module.spaceWatcher then
    module.spaceWatcher:stop()
  end
end

module.on_space_event = function()
  log.i("on_space_event")
  local currSpace = spaces.activeSpace()
  if currSpace ~= module.spaceHistCurr then
    module.spaceHistPrev = module.spaceHistCurr
    module.spaceHistCurr = currSpace
    updateMenuBar()
    log.i("on_space_event: spaceHistPrev", module.spaceHistPrev, ", spaceHistCurr", module.spaceHistCurr)
  end
end

return module
