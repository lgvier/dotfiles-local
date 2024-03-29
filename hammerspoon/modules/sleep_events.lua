local log = hs.logger.new('sleep_events','debug')

local ext_utils = require("ext.utils")

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
  local on = hs.caffeinate.toggle("displayIdle")
  if on then
    local toggleSharingOnSleep = (hostConfig and hostConfig['toggleSharingOnSleep']) or false
    if toggleSharingOnSleep then
      -- local result = os.execute("sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist && sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.smbd.plist");
      -- log.i(result and "filesharing started" or "filesharing start failed")
    end
  end
  setCaffeineDisplay(on)
end

module.start = function()

  module.lastSleep = 0
  module.menubar = hs.menubar.new()
  module.menubar:setClickCallback(caffeineClicked)
  setCaffeineDisplay(hs.caffeinate.get("displayIdle"))

  local toggleSharingOnSleep = (hostConfig and hostConfig['toggleSharingOnSleep']) or false
  local unpairHeadphonesOnSleep = true
  if hostConfig and hostConfig['unpairHeadphonesOnSleep'] ~= nil then 
    unpairHeadphonesOnSleep = hostConfig['unpairHeadphonesOnSleep']
  end
  log.i('toggleSharingOnSleep:', toggleSharingOnSleep, 'unpairHeadphonesOnSleep', unpairHeadphonesOnSleep)
  if toggleSharingOnSleep or unpairHeadphonesOnSleep then
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
        module.lastSleep = 0
      elseif event == pow.screensDidSleep or event == pow.systemWillSleep or event == pow.systemWillPowerOff
        or event == pow.sessionDidResignActive or event == pow.screensDidLock then
        local now = os.time()
        if (now - module.lastSleep) > 5 then
          log.i("sleeping...")
          module.lastSleep = now

          -- if toggleSharingOnSleep then
          -- local result = os.execute("sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.AppleFileServer.plist && sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.smbd.plist");
          -- log.i(result and "filesharing stopped" or "filesharing stop failed")
          -- end

          if unpairHeadphonesOnSleep then
            ext_utils.btUnpair("00-1b-66-81-85-50")
          end
        else
          log.d("ignoring sleep event (just processed another one", (now - module.lastSleep), "second(s) ago)");
        end
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
