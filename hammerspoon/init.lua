local log = hs.logger.new('init.lua','debug')

mash = {"ctrl","alt","cmd"}
ctcm = {"ctrl","cmd"}
atcm = {"alt","cmd"}
atsh = {"alt","shift"}
ctsh = {"ctrl","shift"}

local config = {
  ['Work'] = {
    ['spaceNumberMappings'] = {
      [3] = 5,
      [4] = 6,
      [5] = 3,
      [6] = 4,
    },
  },
  ['MacBook Air'] = {
    ['sleepEventsEnabled'] = true,
  }
}
local hostName = hs.host.localizedName()
log.i('hostName:', hostName)
hostConfig = config[hostName]

function reload_config(files)
  hs.reload()
end
hs.hotkey.bind(mash, "`", reload_config)
hs.pathwatcher.new(os.getenv("HOME") .. "/dotfiles-local/hammerspoon/", reload_config):start()

yabai_extras = require('modules.yabai_extras')
misc_shortcuts = require('modules.misc_shortcuts')
sizeup = require('modules.sizeup')
local modules = { yabai_extras, misc_shortcuts, sizeup }

if hostConfig and hostConfig['sleepEventsEnabled'] then
  sleep_events = require('modules.sleep_events')
  modules[#modules+1] = sleep_events
end

hs.fnutils.each(modules, function(module)
  if module then module.start() end
end)

-- stop modules on shutdown
hs.shutdownCallback = function()
  hs.fnutils.each(modules, function(module)
    if module then module.stop() end
  end)
end

hs.ipc.cliInstall()

log.i("Hammerspoon config loaded")
hs.alert.show("Hammerspoon config loaded")
