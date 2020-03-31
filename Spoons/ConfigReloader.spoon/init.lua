local BaseSpoon = require "Util/BaseSpoon"
local Window    = require "Util/Window"
local obj = BaseSpoon.new()

obj.name = "ConfigReloader"
obj.version = "1.0"
obj.author = "Eugene Ching"
obj.config_path = hs.configdir
obj.watcher = nil

function obj:bindHotkeys(hyper)
    local hyper_types = {"primary", "secondary"}
    local def = {}
    local map = {}

    for i, type in ipairs(hyper_types) do
        for key, name in pairs(self.hotkeys[type]) do
            map[name] = { hyper[type], key}
            def[name] = self[name]
        end
    end

    hs.spoons.bindHotkeysToSpec(def, map)
end

function obj:reloadConfig()
    hs.reload()
    hs.notify.new({title="Hammerspoon Config Reloaded"}):send()
end

function obj:start()
    hs.hotkey.bind({"ctrl", "option", "cmd"}, 'r', self.reloadConfig)

    local function reload()
        self:reloadConfig()
    end
    self.watcher = hs.pathwatcher.new(self.config_path, self.reloadConfig):start()
end

function obj:stop()
    self.watcher.stop()
end

return obj