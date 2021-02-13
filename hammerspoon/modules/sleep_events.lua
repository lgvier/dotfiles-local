local log = hs.logger.new('sleep_events','debug')
local module = { }

local ampOnIcon = [[ASCII:
.....1a..........AC..........E
..............................
......4.......................
1..........aA..........CE.....
e.2......4.3...........h......
..............................
..............................
.......................h......
e.2......6.3..........t..q....
5..........c..........s.......
......6..................q....
......................s..t....
.....5c.......................
]]

local ampOffIcon = [[ASCII:
.....1a.....x....AC.y.......zE
..............................
......4.......................
1..........aA..........CE.....
e.2......4.3...........h......
..............................
..............................
.......................h......
e.2......6.3..........t..q....
5..........c..........s.......
......6..................q....
......................s..t....
...x.5c....y.......z..........
]]

local function setCaffeineDisplay(state)
  if state then
      module.menubar:setIcon(ampOnIcon)
  else
      module.menubar:setIcon(ampOffIcon)
  end
end

local function caffeineClicked()
  setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

module.start = function()

  module.menubar = hs.menubar.new()
  module.menubar:setClickCallback(caffeineClicked)
  setCaffeineDisplay(hs.caffeinate.get("displayIdle"))

  local toggleSharingOnSleep = (hostConfig and hostConfig['toggleSharingOnSleep']) or false
  log.i('toggleSharingOnSleep:', toggleSharingOnSleep)
  if toggleSharingOnSleep then
    local pow = hs.caffeinate.watcher
    module.caffeinate_watcher = hs.caffeinate.watcher.new(function(event)
      log.i("caffeinate event", event)
      -- local name = "?"
      -- for key,val in pairs(pow) do
      --     if event == val then name = key end
      -- end
      -- log.i("caffeinate event", event, "name", name)
      if event == pow.screensDidWake or event == pow.sessionDidBecomeActive or event == pow.screensaverDidStop then
        log.i("awake!")
        local result = os.execute("sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.smbd.plist");
        log.i(result and "filesharing started" or "filesharing start failed")
      elseif event == pow.screensDidSleep or event == pow.systemWillSleep or event == pow.systemWillPowerOff
        or event == pow.sessionDidResignActive or event == pow.screensDidLock then
        log.i("sleeping...")
        local result = os.execute("sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.smbd.plist");
        log.i(result and "filesharing stopped" or "filesharing stop failed")
      end
    end)
    module.caffeinate_watcher:start()
  end

  log.i("sleep_events module started")
end

module.stop = function()
  if module.menubar then
    module.menubar:delete()
  end
  if module.caffeinate_watcher then
    module.caffeinate_watcher:stop()
  end
  log.i("sleep_events module stopped")
end
return module
