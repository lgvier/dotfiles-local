local mash = {"ctrl","alt","cmd"}

--hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
--	hs.reload()
--end)
function reload_config(files)
	hs.reload()
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show("Config loaded")

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
hs.hotkey.bind(mash, 'G', launch_chrome)

function launch_terminal()
	hs.application.launchOrFocus("iTerm")
	-- hs.alert.show("iTerm")
end
hs.hotkey.bind(mash, 'T', launch_terminal)

function launch_vim()
	hs.application.launchOrFocus("MacVim")
	-- hs.alert.show("MacVim")
end
hs.hotkey.bind(mash, 'V', launch_vim)

function launch_outlook()
	hs.application.launchOrFocus("Microsoft Outlook")
	-- hs.alert.show("Outlook")
end
hs.hotkey.bind(mash, 'O', launch_outlook)

function launch_lync()
	hs.application.launchOrFocus("Microsoft Lync")
	-- hs.alert.show("Lync")
end
hs.hotkey.bind(mash, 'I', launch_lync)

function launch_spotify()
	hs.application.launchOrFocus("Slack")
	-- hs.alert.show("Spotify")
end
hs.hotkey.bind(mash, 'S', launch_spotify)


function code_layout()
	launch_chrome()
	launch_terminal()
	-- resize iterm (size bug)
	local win = hs.window.focusedWindow()
	local size = win:size()
	size.h = size.h / 2
	win:setSize(size)
	hs.mjomatic.go({
		"EEEEEEEEEEEEEECCCCCCCCCC",
		"EEEEEEEEEEEEEECCCCCCCCCC",
		"EEEEEEEEEEEEEECCCCCCCCCC",
		"EEEEEEEEEEEEEETTTTTTTTTT",
		"EEEEEEEEEEEEEETTTTTTTTTT",
		"",
		"E Eclipse",
		"C Google Chrome",
		"T iTerm"}
	)
	--os.execute("sleep 1")
	eclipse_focus()
	-- hs.alert.show("Code")
end
hs.hotkey.bind(mash, 'C', code_layout)

function communication_layout()
	-- TODO do it manually instead of using mjomatic (no need to move to another screen)
	-- 
	local outlook = hs.appfinder.appFromName("Microsoft Outlook")
	if not outlook then
		hs.alert.show("Outlook is not running")
		return
	end
	local lync = hs.appfinder.appFromName("Microsoft Lync")
	if not lync then
		hs.alert.show("Lync is not running")
		return
	end
	
	--launch_lync()
	--launch_outlook()
	hs.mjomatic.go({
		"OOOOOOOOOOOOOOOOOOOLLLLL",
		"OOOOOOOOOOOOOOOOOOOLLLLL",
		"OOOOOOOOOOOOOOOOOOOLLLLL",
		"OOOOOOOOOOOOOOOOOOOLLLLL",
		"OOOOOOOOOOOOOOOOOOOLLLLL",
		"",
		"O Microsoft Outlook",
		"L Microsoft Lync"}
	)

	-- local app = hs.appfinder.appFromName("Microsoft Outlook")
	local win = outlook:mainWindow()
	hs.alert.show(win)
	local nextScreen = win:screen():next()
	win:moveToScreen(nextScreen)
	
	-- app = hs.appfinder.appFromName("Microsoft Lync")
	win = lync:mainWindow()
	win:moveToScreen(nextScreen)

	-- hs.alert.show("Communication")
end
hs.hotkey.bind(mash, '2', communication_layout)
