local BaseSpoon = require "Util/BaseSpoon"
local Window    = require "Util/Window"
local obj = BaseSpoon.new()

obj.name = "AppLauncher"
obj.version = "1.0"
obj.author = "Eugene Ching"

function obj.onlyShow(appName)
    hs.application.launchOrFocus(appName)
end

function obj:start()
    hs.hotkey.bind({"cmd"}, 'f1', function() self.onlyShow('slack') end)
    hs.hotkey.bind({"cmd"}, 'f2', function() self.onlyShow('keybase') end)
    hs.hotkey.bind({"cmd"}, 'f3', function() self.onlyShow('signal') end)
    hs.hotkey.bind({"cmd"}, 'f4', function() self.onlyShow('numi') end)
    hs.hotkey.bind({"cmd"}, 'f5', function() self.onlyShow('path finder') end)
    hs.hotkey.bind({"cmd"}, 'f6', function() self.onlyShow('Digital Color Meter') end)
    hs.hotkey.bind({"cmd"}, 'f7', function() self.onlyShow('iterm') end)
    hs.hotkey.bind({"cmd"}, 'f8', function() self.onlyShow('visual studio code') end)
    hs.hotkey.bind({"cmd"}, 'f9', function() self.onlyShow('google chrome') end)
    hs.hotkey.bind({"cmd", "shift"}, 'f9', function() self.onlyShow('google chrome canary') end)
    hs.hotkey.bind({"cmd"}, 'f12', function() self.onlyShow('inkdrop') end)
end

return obj
