local mash = {"ctrl","alt","cmd"}
local ctcm = {"ctrl","cmd"}

function reload_config(files)
   hs.reload()
end
hs.hotkey.bind(mash, "`", reload_config)
-- hs.pathwatcher.new(os.getenv("HOME") .. "/dotfiles-local/hammerspoon/", reload_config):start()

-- 
-- hs.hotkey.bind(mash, "-", function()
--   -- hs.alert.show("Minimize")
--   local app = hs.window.focusedWindow()
--   app:minimize()
-- end)
-- 
-- require "sizeup"
-- 
-- function eclipse_focus()
--   local app = hs.appfinder.appFromName("Eclipse")
--   app:activate()
--   -- hs.alert.show("Eclipse")
-- end
-- hs.hotkey.bind(mash, 'E', eclipse_focus)
-- 
-- function eclipse_run()
--   local app = hs.appfinder.appFromName("Eclipse")
--   app:activate()
--   app:selectMenuItem("Run")
--   hs.alert.show("Eclipse > Run")
-- end
-- hs.hotkey.bind(mash, 'R', eclipse_run)
-- 
-- function eclipse_debug()
--   local app = hs.appfinder.appFromName("Eclipse")
--   app:activate()
--   app:selectMenuItem("Debug")
--   hs.alert.show("Eclipse > Debug")
-- end
-- hs.hotkey.bind(mash, 'D', eclipse_debug)
-- 
-- function idea_focus()
--   local app = hs.appfinder.appFromName("IntelliJ IDEA")
--   app:activate()
-- end
-- hs.hotkey.bind(mash, 'I', idea_focus)
-- 
-- function launch_vscode()
--   hs.application.launchOrFocus("Visual Studio Code")
-- end
-- hs.hotkey.bind(mash, 'V', launch_vscode)
-- 
-- function vscode_run()
--   local app = hs.appfinder.appFromName("Visual Studio Code")
--   app:activate()
--   app:selectMenuItem("Run Without Debugging")
--   hs.alert.show("VSCode > Run")
-- end
-- -- hs.hotkey.bind(mash, 'R', vscode_run)
-- 
-- function vscode_debug()
--   local app = hs.appfinder.appFromName("Visual Studio Code")
--   app:activate()
--   app:selectMenuItem("Start Debugging")
--   hs.alert.show("VSCode > Debug")
-- end
-- -- hs.hotkey.bind(mash, 'D', vscode_debug)
-- 
-- function kill_java()
--   -- ignore VSCode's background process and SQLDeveloper
--   local result = os.execute("kill -9 $(ps aux | grep java | grep -v '.vscode/extensions' | grep -v 'oracle.ide.osgi.boot.OracleIdeLauncher' | grep -v grep | awk '{ print $2 }')")
--   hs.alert.show(result and "Killed java process" or "Java process not found")
-- end
-- hs.hotkey.bind(mash, '9', kill_java)
-- 
-- function kill_tomcat()
--   local result = os.execute("kill -9 `pgrep -f 'pcln/tomcat'`")
--   hs.alert.show(result and "Killed Tomcat" or "Tomcat process not found")
-- end
-- hs.hotkey.bind(mash, '0', kill_tomcat)
-- 
-- function launch_firefox()
--   hs.application.launchOrFocus("Firefox")
--   -- hs.alert.show("Firefox")
-- end
-- hs.hotkey.bind(mash, 'F', launch_firefox)
-- 
-- function launch_chrome()
--   hs.application.launchOrFocus("Google Chrome")
--   -- hs.alert.show("Google Chrome")
-- end
-- hs.hotkey.bind(mash, 'C', launch_chrome)
-- 
-- function launch_terminal()
--   hs.application.launchOrFocus("iTerm")
--   -- hs.alert.show("iTerm")
-- end
-- hs.hotkey.bind(mash, 'T', launch_terminal)
-- 
-- function launch_vim()
--   hs.application.launchOrFocus("VimR")
--   -- hs.alert.show("Vim")
-- end
-- -- hs.hotkey.bind(mash, 'V', launch_vim)
-- 
-- function launch_slack()
--   hs.application.launchOrFocus("Slack")
-- end
-- hs.hotkey.bind(mash, 'S', launch_slack)
-- 
-- function launch_evernote()
--   hs.application.launchOrFocus("Evernote")
-- end
-- hs.hotkey.bind(mash, 'P', launch_evernote)
-- 
-- 
-- function code_layout()
--   launch_chrome()
--   launch_terminal()
-- 
--   -- -- resize iterm (size bug)
--   -- local win = hs.window.focusedWindow()
--   -- local size = win:size()
--   -- size.h = size.h / 2
--   -- win:setSize(size)
-- 
--   hs.mjomatic.go({
--     "EEEEEEEEEEEEEECCCCCCCCCC",
--     "EEEEEEEEEEEEEECCCCCCCCCC",
--     "EEEEEEEEEEEEEECCCCCCCCCC",
--     "EEEEEEEEEEEEEETTTTTTTTTT",
--     "EEEEEEEEEEEEEETTTTTTTTTT",
--     "",
--     "E Eclipse",
--     "C Google Chrome",
--     "T iTerm2"}
--     )
--     --os.execute("sleep 1")
--     eclipse_focus()
--     -- hs.alert.show("Code")
--   end
-- hs.hotkey.bind(mash, '1', code_layout)
--
--
function yabai_cmd(cmd)
  hs.alert.show(cmd)
  status = hs.execute(cmd)
  if not status then
    hs.alert.show("didn't work: [" .. cmd .. "]")
  end
end

-- hs.hotkey.bind(mash, 'h', function() yabai_cmd("/usr/local/bin/yabai -m window --swap west") end)
-- hs.hotkey.bind(ctcm, 'j', function() yabai_cmd("/usr/local/bin/yabai -m window --focus south") end)
-- hs.hotkey.bind(mash, 'j', function() yabai_cmd("/usr/local/bin/yabai -m window --swap south") end)
-- hs.hotkey.bind(ctcm, 'k', function() yabai_cmd("/usr/local/bin/yabai -m window --focus north") end)
-- hs.hotkey.bind(mash, 'k', function() yabai_cmd("/usr/local/bin/yabai -m window --swap north") end)
-- hs.hotkey.bind(ctcm, 'l', function() yabai_cmd("/usr/local/bin/yabai -m window --focus east") end)
-- hs.hotkey.bind(mash, 'l', function() yabai_cmd("/usr/local/bin/yabai -m window --swap east") end)
-- hs.hotkey.bind(mash, '[', function() yabai_cmd(os.getenv("HOME") .. "/.bin/yabai/previousSpace.sh") end)
-- hs.hotkey.bind(mash, ']', function() yabai_cmd(os.getenv("HOME") .. "/.bin/yabai/nextSpace.sh") end)
-- hs.hotkey.bind(mash, ',', function() yabai_cmd(os.getenv("HOME") .. "/.bin/yabai/moveWindowLeftAndFollowFocus.sh") end)
-- hs.hotkey.bind(mash, '.', function() yabai_cmd(os.getenv("HOME") .. "/.bin/yabai/moveWindowRightAndFollowFocus.sh") end)

hs.alert.show("Hammerspoon config loaded")
