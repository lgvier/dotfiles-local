local module = {}
local log = hs.logger.new('spaces_mgmt','debug')

-- spaces management
-- (yabai space management doesnt work well with SIP enabled)

-- https://github.com/asmagill/hs._asm.undocumented.spaces
local spaces = require("hs._asm.undocumented.spaces")
local timer = require("hs.timer")

local ext_screen = require("ext.screen")
local ext_utils = require("ext.utils")

local get_all_space_ids = function()
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
  module.space_ids = result
  log.d('get_all_space_ids space_count: ', #result)
  return result
end

local find_space_screen = function(space)
  local screen_id = spaces.spaceScreenUUID(space)
  local screens = hs.screen.allScreens()
  for sk, screen in pairs(screens) do
    if screen:spacesUUID() == screen_id then
      log.d('find_space_screen space:', space, 'screen:', screen)
      return screen, space
    end
  end
end

local find_next_space = function(fwd)
  local curr_space = spaces.activeSpace()
  log.d('find_next_space fwd?', fwd, 'curr_space:', curr_space)
  local space_ids = get_all_space_ids()
  local space_count = 0
  local space_idx = 0
  for k, v in pairs(space_ids) do
    space_count = space_count + 1
    if v == curr_space then
      space_idx = k
    end
  end
  if fwd then 
    if space_idx == space_count then 
      return space_ids[1]
    else
      return space_ids[space_idx + 1]
    end
  else
    if space_idx == 1 then 
      return space_ids[space_count]
    else
      return space_ids[space_idx - 1]
    end
  end
end

local go_to_space = function(space)
  if space then
    local screen = find_space_screen(space)
    log.i("go_to_space(", space, ") screen#: ", screen)
    if screen ~= hs.screen.mainScreen() then
      log.i('changing focus to screen', screen)
      ext_screen.focusScreen(screen)
    end
    local curr_space = spaces.activeSpace()
    if space ~= curr_space then
      log.i('changing to space', space)
      spaces.changeToSpace(space)
    else
      log.i('space already visible')
    end
  end
end

local move_to_space = function(space, goToNewSpace)
  if space then
    local win = hs.window.focusedWindow()
    local previous_screen = win:screen()
    local screen = find_space_screen(space)
    log.i("move_to_space(", space, ") previous_screen: ", previous_screen, "screen#: ", screen)
    if screen == previous_screen then
      win:spacesMoveTo(space)
    else
      local currentFrame = win:frame()
      local screenFrame = previous_screen:frame()
      local nextScreenFrame = screen:frame()
      win:spacesMoveTo(space)
      win:setFrame({
        x = ((((currentFrame.x - screenFrame.x) / screenFrame.w) * nextScreenFrame.w) + nextScreenFrame.x),
        y = ((((currentFrame.y - screenFrame.y) / screenFrame.h) * nextScreenFrame.h) + nextScreenFrame.y),
        h = ((currentFrame.h / screenFrame.h) * nextScreenFrame.h),
        w = ((currentFrame.w / screenFrame.w) * nextScreenFrame.w)
      })
    end
    if goToNewSpace then
       spaces.changeToSpace(space)
       win:focus()
    else
       ext_screen.focusScreen(screen)
    end
  end
end

local go_back_to_previous_space = function()
  log.i("go_back_to_previous_space spaceHistPrev", module.spaceHistPrev)
  if module.spaceHistPrev then
    go_to_space(module.spaceHistPrev)
  end
end

local move_back_to_previous_space = function(goToNewSpace)
  log.i("move_back_to_previous_space spaceHistPrev", module.spaceHistPrev)
  if module.spaceHistPrev then
    move_to_space(module.spaceHistPrev, goToNewSpace)
  end
end

local go_to_next_space = function(fwd)
  local space = find_next_space(fwd)
  log.i('go_to_next_space - next space fwd?', fwd, ':', space)
  go_to_space(space)
end

local move_to_next_space = function(fwd, goToNewSpace)
  local space = find_next_space(fwd)
  log.i('move_to_next_space - next space fwd?', fwd, ':', space)
  move_to_space(space, goToNewSpace)
end

local go_to_space_n = function(n)
  local space_ids = get_all_space_ids()
  local space = space_ids[n]
  local curr_space = spaces.activeSpace()
  log.i("go_to_space_n(", n, ") space id: ", space, ", curr_space", curr_space)
  if space ~= curr_space then
    go_to_space(space)
  else
    go_back_to_previous_space()
  end
end

local move_to_space_n = function(n, goToNewSpace)
  local space_ids = get_all_space_ids()
  local space = space_ids[n]
  local curr_space = spaces.activeSpace()
  log.i("move_to_space_n(", n, ") space id: ", space, ", curr_space", curr_space)
  if space ~= curr_space then
    move_to_space(space, goToNewSpace)
  else
    move_back_to_previous_space(goToNewSpace)
  end
end

local function update_menu_bar()
  if not module.space_ids then
    get_all_space_ids()
  end
  local curr_space = spaces.activeSpace()

  local t = { }
  local space_count = 0
  for k, v in pairs(module.space_ids) do
    space_count = space_count + 1
    if v == curr_space then
      t[#t+1] = "["
    end
    t[#t+1] = tostring(space_count)
    if v == curr_space then
      t[#t+1] = "]"
    end
  end

  module.menubar:setTitle(table.concat(t))
end

local function init_menu_bar()
  module.menubar = hs.menubar.new()
  module.menubar:setMenu(
    {
      -- { title = "Title", fn = some_function },
    })
  update_menu_bar()
end

module.start = function()
  init_menu_bar()

  hs.hotkey.bind('alt', '[', function() go_to_next_space(false) end)
  hs.hotkey.bind('alt', ']', function() go_to_next_space(true) end)
  hs.hotkey.bind('alt', 'b', function() go_back_to_previous_space() end)
  hs.hotkey.bind(atsh, '[', function() move_to_next_space(false, true) end)
  hs.hotkey.bind(atsh, ']', function() move_to_next_space(true, true) end)
  hs.hotkey.bind(atsh, 'b', function() move_back_to_previous_space(true) end)
  hs.hotkey.bind(ctsh, '[', function() move_to_next_space(false, false) end)
  hs.hotkey.bind(ctsh, ']', function() move_to_next_space(true, false) end)
  hs.hotkey.bind(ctsh, 'b', function() move_back_to_previous_space(false) end)

  hs.hotkey.bind('alt', '1', function() go_to_space_n(1) end)
  hs.hotkey.bind('alt', '2', function() go_to_space_n(2) end)
  hs.hotkey.bind('alt', '3', function() go_to_space_n(3) end)
  hs.hotkey.bind('alt', '4', function() go_to_space_n(4) end)
  hs.hotkey.bind('alt', '5', function() go_to_space_n(5) end)
  hs.hotkey.bind('alt', '6', function() go_to_space_n(6) end)
  hs.hotkey.bind(atsh, '1', function() move_to_space_n(1, true) end)
  hs.hotkey.bind(atsh, '2', function() move_to_space_n(2, true) end)
  hs.hotkey.bind(atsh, '3', function() move_to_space_n(3, true) end)
  hs.hotkey.bind(atsh, '4', function() move_to_space_n(4, true) end)
  hs.hotkey.bind(atsh, '5', function() move_to_space_n(5, true) end)
  hs.hotkey.bind(atsh, '6', function() move_to_space_n(6, true) end)
  hs.hotkey.bind(ctsh, '1', function() move_to_space_n(1, false) end)
  hs.hotkey.bind(ctsh, '2', function() move_to_space_n(2, false) end)
  hs.hotkey.bind(ctsh, '3', function() move_to_space_n(3, false) end)
  hs.hotkey.bind(ctsh, '4', function() move_to_space_n(4, false) end)
  hs.hotkey.bind(ctsh, '5', function() move_to_space_n(5, false) end)
  hs.hotkey.bind(ctsh, '6', function() move_to_space_n(6, false) end)

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
  local curr_space = spaces.activeSpace()
  if curr_space ~= module.spaceHistCurr then
    module.spaceHistPrev = module.spaceHistCurr
    module.spaceHistCurr = curr_space
    update_menu_bar()
    log.i("on_space_event: spaceHistPrev", module.spaceHistPrev, ", spaceHistCurr", module.spaceHistCurr)
  end
end

return module
