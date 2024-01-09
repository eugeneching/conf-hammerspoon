local BaseSpoon = require "Util/BaseSpoon"
local Window    = require "Util/Window"
local obj = BaseSpoon.new()

obj.name = "AppLauncher"
obj.version = "1.0"
obj.author = "Eugene Ching"

function obj:start()
    hs.hotkey.bind({"cmd"}, 'f1', function() hs.application.launchOrFocus('slack') end)
    hs.hotkey.bind({"cmd"}, 'f2', function() hs.application.launchOrFocus('standard notes') end)
    hs.hotkey.bind({"cmd"}, 'f3', function() hs.application.launchOrFocus('telegram a') end)
    hs.hotkey.bind({"cmd"}, 'f4', function() hs.application.launchOrFocus('numi') end)
    hs.hotkey.bind({"cmd"}, 'f5', function() hs.application.launchOrFocus('forklift') end)
    hs.hotkey.bind({"cmd"}, 'f7', function() hs.application.launchOrFocus('iterm') end)
    hs.hotkey.bind({"cmd"}, 'f8', function() hs.application.launchOrFocus('visual studio code') end)
    -- hs.hotkey.bind({"cmd"}, 'f9', function() hs.execute('open -n -a "Google Chrome" --args --profile-directory="Default" about:blank') end)
    hs.hotkey.bind({"cmd"}, 'f9', function() hs.application.launchOrFocus('google chrome') end)
    hs.hotkey.bind({"cmd"}, 'f12', function() hs.application.launchOrFocus('notion') end)
    hs.hotkey.bind({}, 'f15', function() hs.application.launchOrFocus("todoist") end)
end

return obj
