local module = {}
local log = hs.logger.new('yabai_extras','debug')

local function reload_yabai()
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

module.start = function()

  -- hs.pathwatcher.new(os.getenv("HOME") .. "/dotfiles-local/yabairc", reload_yabai):start()
  -- hs.hotkey.bind('alt', 'y', reload_yabai)
  -- hs.pathwatcher.new(os.getenv("HOME") .. "/dotfiles-local/skhdrc", reload_skhdrc):start()

  log.i("yabai_extras module started.")
end

module.stop = function()
end

return module
