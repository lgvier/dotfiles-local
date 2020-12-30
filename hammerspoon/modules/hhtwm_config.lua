local module = {}

local log = hs.logger.new('hhtwm_config','debug')
-- https://github.com/szymonkaliski/hhtwm
hhtwm = require('hhtwm')
local activeScreen = require("ext.screen").activeScreen
local table        = require('ext.table')

local cache = {}

config.wm = {
  defaultDisplayLayouts = {
    ['Color LCD'] = 'tabbed-right',
    ['MPLE27QPM'] = 'main-left'
  },
  displayLayouts = {
    ['Color LCD'] = { 'monocle', 'main-left', 'tabbed-right' },
    ['MPLE27QPM'] = { 'main-left', 'tabbed-right' }
  }
}

config.window = {
  highlightBorder = true,
  highlightMouse  = true,
  historyLimit    = 0
}

local screenWatcher = function(_, _, _, prevScreens, screens)
  log.i('screenWatcher prevScreens: ', prevScreens, 'screens:', screens)
  if prevScreens == nil or #prevScreens == 0 then
    return
  end

  if table.equal(prevScreens, screens) then
    return
  end

  log.i('resetting display layouts')

  hhtwm.displayLayouts = config.wm.defaultDisplayLayouts
  hhtwm.resetLayouts()
  hhtwm.tile()
end

local calcResizeStep = function(screen)
  return 1 / hs.grid.getGrid(screen).w
end

module.setLayout = function(layout)
  hhtwm.setLayout(layout)
  hhtwm.resizeLayout()

  hs.alert.show('Switched to layout: ' .. layout)
end

module.cycleLayout = function()
  local screen = activeScreen()
  log.i('all layouts', hhtwm.getLayouts())
  local layouts = (config.wm.displayLayouts[screen:name()]) or config.wm.defaultDisplayLayouts or hhtwm.getLayouts()
  local currentLayout = hhtwm.getLayout()
  log.i('layouts: ', layouts, 'currentLayout:', currentLayout)
  local currentLayoutIndex = hs.fnutils.indexOf(layouts, currentLayout) or 0

  local nextLayoutIndex = (currentLayoutIndex % #layouts) + 1
  local nextLayout = layouts[nextLayoutIndex]
  

  module.setLayout(nextLayout)
end

module.start = function()

  cache.watcher = hs.watchable.watch('status.connectedScreenIds', screenWatcher)
  log.d('created watcher', cache.watcher)

  os.execute('killall limelight &> /dev/null')
  -- FIXME not loading the config
  local ll_cmd = "/usr/local/bin/limelight -c " .. os.getenv("HOME") .. "/.limelightrc &> /dev/null &"
  local ll_result = os.execute(ll_cmd)
  log.d('started limelight - cmd: ', ll_cmd, ', result: ', ll_result)

  local filters = {
    { app = 'Archive Utility', tile = false                           },
    { app = 'Finder', title = 'Copy', tile = false                    },
    { app = 'Finder', title = 'Move', tile = false                    },
    { app = 'Hammerspoon', title = 'Hammerspoon Console', tile = true },
    { app = 'System Preferences', tile = false                        },
    { app = 'iTerm2', tile = true                                      },
    -- { app = 'iTerm2', subrole = 'AXDialog', tile = false              },
  }

  local isMenubarVisible = hs.screen.primaryScreen():frame().y > 0

  local fullMargin = 12
  local halfMargin = fullMargin / 2

  local screenMargin = {
    top    = (isMenubarVisible and 22 or 0) + halfMargin,
    bottom = halfMargin,
    left   = halfMargin,
    right  = halfMargin
  }

  hhtwm.margin         = fullMargin
  hhtwm.screenMargin   = screenMargin
  hhtwm.filters        = filters
  hhtwm.calcResizeStep = calcResizeStep

  hhtwm.start()
  hs.alert.show("hhtwm_config started")
end

module.stop = function()
  cache.watcher:release()
  hhtwm.stop()
  os.execute('killall limelight &> /dev/null')
  hs.alert.show("hhtwm_config stopped")
end

return module
