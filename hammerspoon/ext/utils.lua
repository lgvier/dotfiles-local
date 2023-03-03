-- https://raw.githubusercontent.com/szymonkaliski/dotfiles/master/Dotfiles/hammerspoon/ext/utils.lua
local log = hs.logger.new('utils','debug')

local module = {}

-- run function without window animation
module.noAnim = function(callback)
  local lastAnimDuration      = hs.window.animationDuration
  hs.window.animationDuration = 0

  callback()

  hs.window.animationDuration = lastAnimDuration
end

-- run cmd and return it's output
module.capture = function(cmd)
  local handle = io.popen(cmd)
  local result = handle:read('*a')

  handle:close()

  return result
end

-- capitalize string
module.capitalize = function(str)
  return str:gsub("^%l", string.upper)
end

module.file_exists = function(path)
  local f=io.open(path,"r")
  if f~=nil then io.close(f) return true else return false end
end

-- https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
module.spairs = function(t, order)
  -- collect the keys
  local keys = {}
  for k in pairs(t) do keys[#keys+1] = k end

  -- if order function given, sort by it by passing the table and keys a, b,
  -- otherwise just sort the keys 
  if order then
      table.sort(keys, function(a,b) return order(t, a, b) end)
  else
      table.sort(keys)
  end

  -- return the iterator function
  local i = 0
  return function()
      i = i + 1
      if keys[i] then
          return keys[i], t[keys[i]]
      end
  end
end


module.btConnect = function(addr)
  local result = os.execute(hostConfig.binPath .. "/blueutil --connect " .. addr)
  log.i('bt connected?', result)
end


module.btPair = function(addr)
  log.i('bt pair', addr)
  local result = os.execute(hostConfig.binPath .. "/blueutil --pair " .. addr)
  log.i('bt paired?', result)
  local result = os.execute(hostConfig.binPath .. "/blueutil --connect " .. addr)
  log.i('bt connected?', result)
end

module.btUnpair = function(addr)
  local result = os.execute(hostConfig.binPath .. "/blueutil --disconnect " .. addr)
  log.i('bt disconnected?', result)
  local result = os.execute(hostConfig.binPath .. "/blueutil --unpair " .. addr)
  log.i('bt unpaired?', result)
end

return module
