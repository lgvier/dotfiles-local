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

  local function idea_focus()
    local app = hs.appfinder.appFromName("IntelliJ IDEA")
    app:activate()
  end
  hs.hotkey.bind(mash, 'I', idea_focus)

  local function launch_vscode()
    hs.application.launchOrFocus("Visual Studio Code")
  end
  hs.hotkey.bind(mash, 'V', launch_vscode)

  local function vscode_run()
    local app = hs.appfinder.appFromName("Visual Studio Code")
    app:activate()
    app:selectMenuItem("Run Without Debugging")
    hs.alert.show("VSCode > Run")
  end
  -- hs.hotkey.bind(mash, 'R', vscode_run)

  local function vscode_debug()
    local app = hs.appfinder.appFromName("Visual Studio Code")
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
    local result = os.execute("kill -9 `pgrep -f 'pcln/tomcat'`")
    hs.alert.show(result and "Killed Tomcat" or "Tomcat process not found")
  end
  hs.hotkey.bind(mash, '0', kill_tomcat)

  local function launch_firefox()
    hs.application.launchOrFocus("Firefox")
    -- hs.alert.show("Firefox")
  end
  hs.hotkey.bind(mash, 'F', launch_firefox)

  local function launch_chrome()
    hs.application.launchOrFocus("Google Chrome")
    -- hs.alert.show("Google Chrome")
  end
  hs.hotkey.bind(mash, 'C', launch_chrome)

  local function launch_terminal()
    hs.application.launchOrFocus("iTerm")
    -- hs.alert.show("iTerm")
  end
  hs.hotkey.bind(mash, 'T', launch_terminal)

  local function launch_vim()
    hs.application.launchOrFocus("VimR")
    -- hs.alert.show("Vim")
  end
  -- hs.hotkey.bind(mash, 'V', launch_vim)

  local function launch_slack()
    hs.application.launchOrFocus("Slack")
  end
  hs.hotkey.bind(mash, 'S', launch_slack)

  local function launch_evernote()
    hs.application.launchOrFocus("Evernote")
  end
  hs.hotkey.bind(mash, 'P', launch_evernote)

--  local function code_layout()
--    launch_chrome()
--    launch_terminal()
-- 
--    -- -- resize iterm (size bug)
--    -- local win = hs.window.focusedWindow()
--    -- local size = win:size()
--    -- size.h = size.h / 2
--    -- win:setSize(size)
--
--    hs.mjomatic.go({
--      "EEEEEEEEEEEEEECCCCCCCCCC",
--      "EEEEEEEEEEEEEECCCCCCCCCC",
--      "EEEEEEEEEEEEEECCCCCCCCCC",
--      "EEEEEEEEEEEEEETTTTTTTTTT",
--      "EEEEEEEEEEEEEETTTTTTTTTT",
--      "",
--      "E Eclipse",
--      "C Google Chrome",
--      "T iTerm2"}
--      )
--      --os.execute("sleep 1")
--      eclipse_focus()
--      -- hs.alert.show("Code")
--    end
--  hs.hotkey.bind(mash, '1', code_layout)

  log.i("misc_shortcuts module started")
end

module.stop = function()

end

return module
