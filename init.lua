hs.window.animationDuration = 0

local spoons = {
    ConfigReloader = true,
    WindowGridSnapping = true,
    WindowMouseSnapping = true,
    AppLauncher = true
}

for spoonName, enabled in pairs(spoons) do
    if enabled then
        hs.loadSpoon(spoonName)
        spoon[spoonName].start(spoon[spoonName])
        spoon[spoonName].bindHotkeys(spoon[spoonName])
        spoon[spoonName].bindMouseEvents(spoon[spoonName])
    end
end
