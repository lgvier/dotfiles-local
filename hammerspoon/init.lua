local log = hs.logger.new('init.lua','debug')
local ext_utils = require("ext.utils")

mash = {"ctrl","alt","cmd"}
ctcm = {"ctrl","cmd"}
atcm = {"alt","cmd"}
atsh = {"alt","shift"}
ctsh = {"ctrl","shift"}

local function getBinPath()
  -- default on apple silicon
  local binPath = "/opt/homebrew/bin"
  if not ext_utils.file_exists(binPath .. "/yabai") then
    -- default on intel silicon
    binPath = "/usr/local/bin"
  end
  return binPath
end

local config = {
  ['MacBook Air'] = {
    ['app-vscode'] = 'Visual Studio Code - Insiders', -- arm64 binaries
    ['app-terminal'] = 'Terminal', -- saves battery
    ['toggleSharingOnSleep'] = true,
  }
}
local hostName = hs.host.localizedName()
log.i('hostName:', hostName)
hostConfig = config[hostName] or {}
hostConfig.binPath = getBinPath()
-- log.i('hostConfig:', hostConfig['spaceNumberMappings'])

function reload_config(files)
  hs.reload()
end
hs.hotkey.bind(mash, "`", reload_config)
hs.pathwatcher.new(os.getenv("HOME") .. "/dotfiles-local/hammerspoon/", reload_config):start()

yabai_extras = require('modules.yabai_extras')
spaces_mgmt = require('modules.spaces_mgmt')
misc_shortcuts = require('modules.misc_shortcuts')
sizeup = require('modules.sizeup')
sleep_events = require('modules.sleep_events')
local modules = { yabai_extras, spaces_mgmt, misc_shortcuts, sizeup, sleep_events }

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
