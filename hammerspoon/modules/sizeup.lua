-- === sizeup ===
--
-- SizeUp emulation for hammerspoon
--
-- To use, you can tweak the key bindings and the margins

local module = { }

module.start = function()

  --------------
  -- Bindings --
  --------------

  --- Split Screen Actions ---
  -- Send Window Left
  hs.hotkey.bind(mash, "H", function()
  	module.send_window_left()
  end)
  -- Send Window Right
  hs.hotkey.bind(mash, "L", function()
  	module.send_window_right()
  end)
  -- Send Window Up
  hs.hotkey.bind(mash, "K", function()
  	module.send_window_up()
  end)
  -- Send Window Down
  hs.hotkey.bind(mash, "J", function()
  	module.send_window_down()
  end)

  --- Quarter Screen Actions ---
  -- Send Window Upper Left
  hs.hotkey.bind(mash, "Y", function()
  	module.send_window_upper_left()
  end)
  -- Send Window Upper Right
  hs.hotkey.bind(mash, "U", function()
  	module.send_window_upper_right()
  end)
  -- Send Window Lower Left
  hs.hotkey.bind(mash, "B", function()
  	module.send_window_lower_left()
  end)
  -- Send Window Lower Right
  hs.hotkey.bind(mash, "N", function()
  	module.send_window_lower_right()
  end)

  -- Send Window Left 70%
  hs.hotkey.bind(mash, "[", function()
  	module.send_window_left_70()
  end)
  -- Send Window Right 30%
  hs.hotkey.bind(mash, "]", function()
  	module.send_window_right_30()
  end)

  --- Multiple Monitor Actions ---
  -- Send Window Prev Monitor
  hs.hotkey.bind(mash, ",", function()
  	module.send_window_prev_monitor()
  end)
  -- Send Window Next Monitor
  hs.hotkey.bind(mash, ".", function()
  	module.send_window_next_monitor()
  end)

  --- Spaces Actions ---

  -- Apple no longer provides any reliable API access to spaces.
  -- As such, this feature no longer works in SizeUp on Yosemite and
  -- Hammerspoon currently has no solution that isn't a complete hack.
  -- If you have any ideas, please visit the ticket

  --- Snapback Action ---
  hs.hotkey.bind(mash, "=", function()
  	module.snapback()
  end)
  --- Other Actions ---
  -- Make Window Full Screen
  hs.hotkey.bind(mash, "M", function()
  	module.maximize()
  end)
  -- Send Window Center
  hs.hotkey.bind(mash, "\\", function()
  	-- module.move_to_center_absolute({w=800, h=600})
  	module.move_to_center_relative({w=0.75, h=0.75})
  end)

end

module.stop = function()
end

-------------------
-- Configuration --
-------------------

-- Margins --
module.screen_edge_margins = {
	top =    0, -- px
	left =   0,
	right =  0,
	bottom = 0
}
module.partition_margins = {
	x = 0, -- px
	y = 0
}

-- Partitions --
module.split_screen_partitions = {
	x = 0.5, -- %
	y = 0.5
}
module.split_screen_partitions_70 = {
	x = 0.7, -- %
	y = 0.7
}
module.quarter_screen_partitions = {
	x = 0.5, -- %
	y = 0.5
}


----------------
-- Public API --
----------------

function module.send_window_left()
	local s = module.screen()
	local ssp = module.split_screen_partitions
	local g = module.gutter()
	module.set_frame("Left", {
		x = s.x,
		y = s.y,
		w = (s.w * ssp.x) - module.gutter().x,
		h = s.h
	})
end

function module.send_window_left_70()
	local s = module.screen()
	local ssp = module.split_screen_partitions_70
	local g = module.gutter()
	module.set_frame("Left 70%", {
		x = s.x,
		y = s.y,
		w = (s.w * ssp.x) - module.gutter().x,
		h = s.h
	})
end

function module.send_window_right()
	local s = module.screen()
	local ssp = module.split_screen_partitions
	local g = module.gutter()
	module.set_frame("Right", {
		x = s.x + (s.w * ssp.x) + g.x,
		y = s.y,
		w = (s.w * (1 - ssp.x)) - g.x,
		h = s.h
	})
end

function module.send_window_right_30()
	local s = module.screen()
	local ssp = module.split_screen_partitions_70
	local g = module.gutter()
	module.set_frame("Right 30%", {
		x = s.x + (s.w * ssp.x) + g.x,
		y = s.y,
		w = (s.w * (1 - ssp.x)) - g.x,
		h = s.h
	})
end

function module.send_window_up()
	local s = module.screen()
	local ssp = module.split_screen_partitions
	local g = module.gutter()
	module.set_frame("Up", {
		x = s.x,
		y = s.y,
		w = s.w,
		h = (s.h * ssp.y) - g.y
	})
end

function module.send_window_down()
	local s = module.screen()
	local ssp = module.split_screen_partitions
	local g = module.gutter()
	module.set_frame("Down", {
		x = s.x,
		y = s.y + (s.h * ssp.y) + g.y,
		w = s.w,
		h = (s.h * (1 - ssp.y)) - g.y
	})
end

function module.send_window_upper_left()
	local s = module.screen()
	local qsp = module.quarter_screen_partitions
	local g = module.gutter()
	module.set_frame("Upper Left", {
		x = s.x,
		y = s.y,
		w = (s.w * qsp.x) - g.x,
		h = (s.h * qsp.y) - g.y
	})
end

function module.send_window_upper_right()
	local s = module.screen()
	local qsp = module.quarter_screen_partitions
	local g = module.gutter()
	module.set_frame("Upper Right", {
		x = s.x + (s.w * qsp.x) + g.x,
		y = s.y,
		w = (s.w * (1 - qsp.x)) - g.x,
		h = (s.h * (qsp.y)) - g.y
	})
end

function module.send_window_lower_left()
	local s = module.screen()
	local qsp = module.quarter_screen_partitions
	local g = module.gutter()
	module.set_frame("Lower Left", {
		x = s.x,
		y = s.y + (s.h * qsp.y) + g.y,
		w = (s.w * qsp.x) - g.x,
		h = (s.h * (1 - qsp.y)) - g.y
	})
end

function module.send_window_lower_right()
	local s = module.screen()
	local qsp = module.quarter_screen_partitions
	local g = module.gutter()
	module.set_frame("Lower Right", {
		x = s.x + (s.w * qsp.x) + g.x,
		y = s.y + (s.h * qsp.y) + g.y,
		w = (s.w * (1 - qsp.x)) - g.x,
		h = (s.h * (1 - qsp.y)) - g.y
	})
end

function module.send_window_prev_monitor()
	hs.alert.show("Prev Monitor")
	local win = hs.window.focusedWindow()
	local nextScreen = win:screen():previous()
	win:moveToScreen(nextScreen)
end

function module.send_window_next_monitor()
	hs.alert.show("Next Monitor")
	local win = hs.window.focusedWindow()
	local nextScreen = win:screen():next()
	win:moveToScreen(nextScreen)
end

-- snapback return the window to its last position. calling snapback twice returns the window to its original position.
-- snapback holds state for each window, and will remember previous state even when focus is changed to another window.
function module.snapback()
	hs.alert.show("Snapback")
	local win = module.win()
	local id = win:id()
	local state = win:frame()
	local prev_state = module.snapback_window_state[id]
	if prev_state then
		win:setFrame(prev_state)
	end
	module.snapback_window_state[id] = state
end

function module.maximize()
	module.set_frame("Full Screen", module.screen())
end

--- move_to_center_relative(size)
--- Method
--- Centers and resizes the window to the the fit on the given portion of the screen.
--- The argument is a size with each key being between 0.0 and 1.0.
--- Example: win:move_to_center_relative(w=0.5, h=0.5) -- window is now centered and is half the width and half the height of screen
function module.move_to_center_relative(unit)
	local s = module.screen()
	module.set_frame("Center", {
		x = s.x + (s.w * ((1 - unit.w) / 2)),
		y = s.y + (s.h * ((1 - unit.h) / 2)),
		w = s.w * unit.w,
		h = s.h * unit.h
	})
end

--- move_to_center_absolute(size)
--- Method
--- Centers and resizes the window to the the fit on the given portion of the screen given in pixels.
--- Example: win:move_to_center_relative(w=800, h=600) -- window is now centered and is 800px wide and 600px high
function module.move_to_center_absolute(unit)
	local s = module.screen()
	module.set_frame("Center", {
		x = (s.w - unit.w) / 2,
		y = (s.h - unit.h) / 2,
		w = unit.w,
		h = unit.h
	})
end


------------------
-- Internal API --
------------------

-- SizeUp uses no animations 
hs.window.animation_duration = 0.0
-- Initialize Snapback state
module.snapback_window_state = { }
-- return currently focused window
function module.win()
	return hs.window.focusedWindow()
end
-- display title, save state and move win to unit
function module.set_frame(title, unit)
	hs.alert.show(title)
	local win = module.win()
	module.snapback_window_state[win:id()] = win:frame()
	return win:setFrame(unit)
end
-- screen is the available rect inside the screen edge margins
function module.screen()
	local screen = module.win():screen():frame()
	local sem = module.screen_edge_margins
	return {
		x = screen.x + sem.left,
		y = screen.y + sem.top,
		w = screen.w - (sem.left + sem.right),
		h = screen.h - (sem.top + sem.bottom)
	}
end
-- gutter is the adjustment required to accomidate partition
-- margins between windows
function module.gutter()
	local pm = module.partition_margins
	return {
		x = pm.x / 2,
		y = pm.y / 2
	}
end

--- hs.window:moveToScreen(screen)
--- Method
--- move window to the the given screen, keeping the relative proportion and position window to the original screen.
--- Example: win:moveToScreen(win:screen():next()) -- move window to next screen
function hs.window:moveToScreen(nextScreen)
	local currentFrame = self:frame()
	local screenFrame = self:screen():frame()
	local nextScreenFrame = nextScreen:frame()
	self:setFrame({
		x = ((((currentFrame.x - screenFrame.x) / screenFrame.w) * nextScreenFrame.w) + nextScreenFrame.x),
		y = ((((currentFrame.y - screenFrame.y) / screenFrame.h) * nextScreenFrame.h) + nextScreenFrame.y),
		h = ((currentFrame.h / screenFrame.h) * nextScreenFrame.h),
		w = ((currentFrame.w / screenFrame.w) * nextScreenFrame.w)
	})
end

return module
