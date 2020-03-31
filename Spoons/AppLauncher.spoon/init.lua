local cmd = {"cmd"}

-- Load Dependencies
local BaseSpoon = require "Util/BaseSpoon"
local Window    = require "Util/Window"

-- Spoon Container Object
local obj = BaseSpoon.new()

-- Spoon Metadata
obj.name = "AppLauncher"
obj.version = "1.0"
obj.author = "Mike Trpcic"

-- Spoon Configuration Variables
obj.config_path = hs.configdir

-- Spoon Locals
obj.watcher = nil

-- Spoon Methods
function obj.onlyShow(appName)
    hs.application.launchOrFocus(appName)
end

function obj:start()
    hs.hotkey.bind(cmd, 'f1', function() self.onlyShow('slack') end)
    hs.hotkey.bind(cmd, 'f2', function() self.onlyShow('keybase') end)
    hs.hotkey.bind(cmd, 'f3', function() self.onlyShow('signal') end)
    hs.hotkey.bind(cmd, 'f4', function() self.onlyShow('numi') end)
    hs.hotkey.bind(cmd, 'f5', function() self.onlyShow('path finder') end)
    hs.hotkey.bind(cmd, 'f6', function() self.onlyShow('gitkraken') end)
    hs.hotkey.bind(cmd, 'f7', function() self.onlyShow('iterm') end)
    hs.hotkey.bind(cmd, 'f8', function() self.onlyShow('visual studio code') end)
    hs.hotkey.bind(cmd, 'f9', function() self.onlyShow('google chrome') end)
    hs.hotkey.bind(cmdShift, 'f9', function() self.onlyShow('brave browser') end)
    hs.hotkey.bind(cmd, 'f12', function() self.onlyShow('standard notes') end)
end

return obj