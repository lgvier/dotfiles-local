local mash = {"ctrl","alt","cmd"}

hs.hotkey.bind(mash, "`", function()
  hs.reload()
end)
function reload_config(files)
  hs.reload()
end
-- hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show("Hammerspoon config loaded")

hs.hotkey.bind(mash, "-", function()
  -- hs.alert.show("Minimize")
  local app = hs.window.focusedWindow()
  app:minimize()
end)

require "sizeup"

function eclipse_focus()
  local app = hs.appfinder.appFromName("Eclipse")
  app:activate()
  -- hs.alert.show("Eclipse")
end
hs.hotkey.bind(mash, 'E', eclipse_focus)

function eclipse_run()
  local app = hs.appfinder.appFromName("Eclipse")
  app:activate()
  app:selectMenuItem("Run")
  hs.alert.show("Eclipse > Run")
end
hs.hotkey.bind(mash, 'R', eclipse_run)

function eclipse_debug()
  local app = hs.appfinder.appFromName("Eclipse")
  app:activate()
  app:selectMenuItem("Debug")
  hs.alert.show("Eclipse > Debug")
end
hs.hotkey.bind(mash, 'D', eclipse_debug)

function idea_focus()
  local app = hs.appfinder.appFromName("IntelliJ IDEA")
  app:activate()
end
hs.hotkey.bind(mash, 'I', idea_focus)

function kill_java()
  local result = os.execute("killall -9 java")
  hs.alert.show(result and "Killed Java" or "Java process not found")
end
hs.hotkey.bind(mash, '9', kill_java)

function kill_tomcat()
  local result = os.execute("kill -9 `pgrep -f 'pcln/tomcat'`")
  hs.alert.show(result and "Killed Tomcat" or "Tomcat process not found")
end
hs.hotkey.bind(mash, '0', kill_tomcat)

function launch_firefox()
  hs.application.launchOrFocus("Firefox")
  -- hs.alert.show("Firefox")
end
hs.hotkey.bind(mash, 'F', launch_firefox)

function launch_chrome()
  hs.application.launchOrFocus("Google Chrome")
  -- hs.alert.show("Google Chrome")
end
hs.hotkey.bind(mash, 'C', launch_chrome)

function launch_terminal()
  hs.application.launchOrFocus("iTerm")
  -- hs.alert.show("iTerm")
end
hs.hotkey.bind(mash, 'T', launch_terminal)

function launch_vim()
  hs.application.launchOrFocus("VimR")
  -- hs.alert.show("Vim")
end
hs.hotkey.bind(mash, 'V', launch_vim)

function launch_slack()
  hs.application.launchOrFocus("Slack")
end
hs.hotkey.bind(mash, 'S', launch_slack)

function launch_evernote()
  hs.application.launchOrFocus("Evernote")
end
hs.hotkey.bind(mash, 'P', launch_evernote)


function code_layout()
  launch_chrome()
  launch_terminal()

  -- -- resize iterm (size bug)
  -- local win = hs.window.focusedWindow()
  -- local size = win:size()
  -- size.h = size.h / 2
  -- win:setSize(size)

  hs.mjomatic.go({
    "EEEEEEEEEEEEEECCCCCCCCCC",
    "EEEEEEEEEEEEEECCCCCCCCCC",
    "EEEEEEEEEEEEEECCCCCCCCCC",
    "EEEEEEEEEEEEEETTTTTTTTTT",
    "EEEEEEEEEEEEEETTTTTTTTTT",
    "",
    "E Eclipse",
    "C Google Chrome",
    "T iTerm2"}
    )
    --os.execute("sleep 1")
    eclipse_focus()
    -- hs.alert.show("Code")
  end
hs.hotkey.bind(mash, '1', code_layout)

