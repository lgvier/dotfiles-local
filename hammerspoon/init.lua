local log = hs.logger.new('init.lua','debug')

mash = {"ctrl","alt","cmd"}
ctcm = {"ctrl","cmd"}
atcm = {"alt","cmd"}
atsh = {"alt","shift"}

config = {} 

function reload_config(files)
  hs.reload()
end
hs.hotkey.bind(mash, "`", reload_config)
hs.pathwatcher.new(os.getenv("HOME") .. "/dotfiles-local/hammerspoon/", reload_config):start()

-- hhtwm_config = require('modules.hhtwm_config');
-- hhtwm_shortcuts = require('modules.hhtwm_shortcuts');
-- local modules = { hhtwm_shortcuts, hhtwm_config }
yabai_extras = require('modules.yabai_extras');
misc_shortcuts = require('modules.misc_shortcuts');
sizeup = require('modules.sizeup');
local modules = { yabai_extras, misc_shortcuts, sizeup }

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
