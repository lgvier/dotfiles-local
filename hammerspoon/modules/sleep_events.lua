local log = hs.logger.new('sleep_events','debug')

local module = { }
module.start = function()
  local pow = hs.caffeinate.watcher
  module.caffeinate_watcher = hs.caffeinate.watcher.new(function(event)
    -- log.i("caffeinate event", event)
    -- local name = "?"
    -- for key,val in pairs(pow) do
    --     if event == val then name = key end
    -- end
    log.i("caffeinate event", event, "name", name)
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
  log.i("sleep_events module started")
end

module.stop = function()
  if module.caffeinate_watcher then
    module.caffeinate_watcher:stop()
  end
  log.i("sleep_events module stopped")
end
return module