local module = {}
local log = hs.logger.new('misc_shortcuts','debug')

module.start = function()

  -- hs.hotkey.bind(mash, "-", function()
  --   -- hs.alert.show("Minimize")
  --   local app = hs.window.focusedWindow()
  --   app:minimize()
  -- end)

  local function eclipse_focus()
    local app = hs.appfinder.appFromName("Eclipse")
    app:activate()
    -- hs.alert.show("Eclipse")
  end
  hs.hotkey.bind(mash, 'E', eclipse_focus)

  local function eclipse_run()
    local app = hs.appfinder.appFromName("Eclipse")
    app:activate()
    app:selectMenuItem("Run")
    hs.alert.show("Eclipse > Run")
  end
  hs.hotkey.bind(mash, 'R', eclipse_run)

  local function eclipse_debug()
    local app = hs.appfinder.appFromName("Eclipse")
    app:activate()
    app:selectMenuItem("Debug")
    hs.alert.show("Eclipse > Debug")
  end
  hs.hotkey.bind(mash, 'D', eclipse_debug)

  local function launch_vscode()
    hs.application.launchOrFocus(hostConfig['app-vscode'] or "Visual Studio Code")
  end
  hs.hotkey.bind(mash, 'C', launch_vscode)

  local function vscode_run()
    local app = hs.appfinder.appFromName(hostConfig['app-vscode'] or "Visual Studio Code")
    app:activate()
    app:selectMenuItem("Run Without Debugging")
    hs.alert.show("VSCode > Run")
  end
  -- hs.hotkey.bind(mash, 'R', vscode_run)

  local function vscode_debug()
    local app = hs.appfinder.appFromName(hostConfig['app-vscode'] or "Visual Studio Code")
    app:activate()
    app:selectMenuItem("Start Debugging")
    hs.alert.show("VSCode > Debug")
  end
  -- hs.hotkey.bind(mash, 'D', vscode_debug)

  local function kill_java()
    -- ignore VSCode's background process and SQLDeveloper
    local result = os.execute("kill -9 $(ps aux | grep java | grep -v '.vscode/extensions' | grep -v 'oracle.ide.osgi.boot.OracleIdeLauncher' | grep -v grep | awk '{ print $2 }')")
    hs.alert.show(result and "Killed java process" or "Java process not found")
  end
  hs.hotkey.bind(mash, '9', kill_java)

  local function kill_tomcat()
    local result = os.execute("kill -9 `pgrep -f 'tomcat'`")
    hs.alert.show(result and "Killed Tomcat" or "Tomcat process not found")
  end
  hs.hotkey.bind(mash, '0', kill_tomcat)

  hs.hotkey.bind(mash, 'F', function() hs.application.launchOrFocus("Firefox") end)
  hs.hotkey.bind(mash, 'G', function() hs.application.launchOrFocus("Google Chrome") end)
  hs.hotkey.bind(mash, 'T', function() hs.application.launchOrFocus("Alacritty") end)
  hs.hotkey.bind(mash, 'S', function() hs.application.launchOrFocus("Slack") end)
  hs.hotkey.bind(mash, 'P', function() hs.application.launchOrFocus("Evernote") end)
  hs.hotkey.bind(mash, 'O', function() hs.application.launchOrFocus("Spotify") end)
  hs.hotkey.bind(mash, 'W', function() hs.application.launchOrFocus("WhatsApp") end)
  hs.hotkey.bind(mash, 'I', function() hs.application.launchOrFocus("Safari") end)
  hs.hotkey.bind(mash, 'Z', function() hs.application.launchOrFocus("zoom.us") end)

  local function btConnect(addr)
    local result = os.execute(hostConfig.binPath .. "/blueutil --connect " .. addr)
    log.i('bt connected?', result)
  end
  -- momentum
  hs.hotkey.bind(mash, '1', function() btConnect("00-1b-66-81-85-50") end)

  log.i("misc_shortcuts module started")
end

module.stop = function()

end

return module
