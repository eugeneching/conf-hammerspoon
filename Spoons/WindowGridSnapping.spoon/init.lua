local BaseSpoon = require "Util/BaseSpoon"
local Window    = require "Util/Window"
local obj = BaseSpoon.new()

obj.name = "WindowGradSnapping"
obj.version = "1.0"
obj.author = "Eugene Ching"
obj.replaceFullscreenWithMaximize = false

function isAlreadyAtPosition(target)
    local win = hs.window.focusedWindow()
    if
        math.abs(win:frame().x - target.x) <= 15 and
        math.abs(win:frame().y - target.y) <= 15 and
        math.abs(win:frame().w - target.w) <= 15 and
        math.abs(win:frame().h - target.h) <= 15
    then
        return true
    else
        return false
    end
end

function flip(originX, factor, screen)
    if originX == screen:frame().x then
        return screen:frame().x + (factor - 1) * screen:frame().w/factor
    else
        return screen:frame().x
    end
end

function isWindowMaximized(win)
    if win:frame().x == win:screen():frame().x and win:frame().x + win:frame().w == win:screen():frame().w then
        return true
    end

    return false
end

function isTetheredToLeftEdge(win)
    if win:frame().x == win:screen():frame().x then
        return true
    end

    return false
end

function isTetheredToRightEdge(win)
    if win:frame().x + win:frame().w == win:screen():frame().w then
        return true
    end

    return false
end

function move(target)
    local win = hs.window.focusedWindow()
    local newFrame = win:frame()

    newFrame.x = target.x
    newFrame.y = target.y
    newFrame.w = target.w
    newFrame.h = target.h

    win:setFrame(newFrame)
end

function moveFullScreen()
    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local target = {
            x = win:screen():frame().x,
            y = win:screen():frame().y,
            w = win:screen():frame().w,
            h = win:screen():frame().h
        }

        move(target)
    end
end

function moveCenter()
    local factors = {1.33, 1.5, 1.66, 2}
    local currentFactorIndex = 0

    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local targets = {}

        for i, factor in ipairs(factors) do
            local target = {
                x = win:screen():frame().x + (win:screen():frame().w - win:screen():frame().w/factor)/2,
                y = win:screen():frame().y + (win:screen():frame().h - win:screen():frame().h/factor)/2,
                w = win:screen():frame().w/factor,
                h = win:screen():frame().h/factor
            }

            table.insert(targets, target)

            if isAlreadyAtPosition(target) then
                currentFactorIndex = i
            end
        end

        if currentFactorIndex == #factors then
            currentFactorIndex = 0
        end

        move(targets[currentFactorIndex+1])
   end
end

function moveLeftHalf()
    local factor = 2

    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local target = {
            x = win:screen():frame().x,
            y = win:screen():frame().y,
            w = win:screen():frame().w/factor,
            h = win:screen():frame().h
        }

        if isAlreadyAtPosition(target) then
            local nextScreen = win:screen():toWest()
            if not nextScreen then
                return
            end
            target = {
                x = flip(nextScreen:frame().x, factor, nextScreen),
                y = nextScreen:frame().y,
                w = nextScreen:frame().w/factor,
                h = nextScreen:frame().h
            }
        end

        move(target)
    end
end

function moveRightHalf()
    local factor = 2

    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local target = {
            x = win:screen():frame().x + win:screen():frame().w/factor,
            y = win:screen():frame().y,
            w = win:screen():frame().w/factor,
            h = win:screen():frame().h
        }

        if isAlreadyAtPosition(target) then
            local nextScreen = win:screen():toEast()
            if not nextScreen then
                return
            end
            target = {
                x = flip(nextScreen:frame().x + nextScreen:frame().w/factor, factor, nextScreen),
                y = nextScreen:frame().y,
                w = nextScreen:frame().w/factor,
                h = nextScreen:frame().h
            }
        end

        move(target)
    end
end

function moveLeftUpQuarter()
    local factor = 2

    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local target = {
            x = win:screen():frame().x,
            y = win:screen():frame().y,
            w = win:screen():frame().w/factor,
            h = win:screen():frame().h/factor
        }

        if isAlreadyAtPosition(target) then
            local nextScreen = win:screen():previous()
            target = {
                x = flip(nextScreen:frame().x, factor, nextScreen),
                y = nextScreen:frame().y,
                w = nextScreen:frame().w/factor,
                h = nextScreen:frame().h/factor
            }
        end

        move(target)
    end
end

function moveLeftDownQuarter()
    local factor = 2

    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local target = {
            x = win:screen():frame().x,
            y = win:screen():frame().y + win:screen():frame().h/factor,
            w = win:screen():frame().w/factor,
            h = win:screen():frame().h/factor
        }

        if isAlreadyAtPosition(target) then
            local nextScreen = win:screen():previous()
            target = {
                x = flip(nextScreen:frame().x, factor, nextScreen),
                y = win:screen():frame().y + win:screen():frame().h/factor,
                w = nextScreen:frame().w/factor,
                h = nextScreen:frame().h/factor
            }
        end

        move(target)
    end
end


function moveRightUpQuarter()
    local factor = 2

    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local target = {
            x = win:screen():frame().x + win:screen():frame().w/factor,
            y = win:screen():frame().y,
            w = win:screen():frame().w/factor,
            h = win:screen():frame().h/factor
        }

        if isAlreadyAtPosition(target) then
            local nextScreen = win:screen():next()
            target = {
                x = flip(nextScreen:frame().x + win:screen():frame().w/factor, factor, nextScreen),
                y = nextScreen:frame().y,
                w = nextScreen:frame().w/factor,
                h = nextScreen:frame().h/factor
            }
        end

        move(target)
    end
end

function moveRightDownQuarter()
    local factor = 2

    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local target = {
            x = win:screen():frame().x + win:screen():frame().w/factor,
            y = win:screen():frame().y + win:screen():frame().h/factor,
            w = win:screen():frame().w/factor,
            h = win:screen():frame().h/factor
        }

        if isAlreadyAtPosition(target) then
            local nextScreen = win:screen():next()
            target = {
                x = flip(nextScreen:frame().x + win:screen():frame().w/factor, factor, nextScreen),
                y = win:screen():frame().y + win:screen():frame().h/factor,
                w = nextScreen:frame().w/factor,
                h = nextScreen:frame().h/factor
            }
        end

        move(target)
    end
end

function moveLeftMonitor()
    local factor = 1

    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local prevScreen = win:screen():previous()

        win:moveToScreen(prevScreen, false, true)
    end

end

function moveRightMonitor()
    local factor = 1

    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local nextScreen = win:screen():next()

        win:moveToScreen(nextScreen, false, true)
    end

end

function growShrinkToLeft()
    local factor = 6

    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local newFrame = win:frame()
        local delta = win:screen():frame().w / factor

        if isWindowMaximized(win) then
            -- Window is maximized, shrink right edge
            newFrame.w = newFrame.w - delta

        elseif isTetheredToLeftEdge(win) then
            -- Window is on left-edge, shrink right edge
            newFrame.w = newFrame.w - delta

        elseif isTetheredToRightEdge(win) then
            -- Window is on right-edge, grow left edge
            newFrame.x = newFrame.x - delta
            newFrame.w = newFrame.w + delta

        else
            -- Do nothing
            return
        end

        win:setFrame(newFrame)
    end
end

function growShrinkToRight()
    local factor = 6

    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local newFrame = win:frame()
        local delta = win:screen():frame().w / factor

        if isWindowMaximized(win) then
            -- Window is maximized, shrink left edge
            newFrame.x = newFrame.x + delta
            newFrame.w = newFrame.w - delta

        elseif isTetheredToLeftEdge(win) then
            -- Window is on left-edge, grow right edge
            newFrame.w = newFrame.w + delta

        elseif isTetheredToRightEdge(win) then
            -- Window is on right-edge, shrink left edge
            newFrame.x = newFrame.x + delta
            newFrame.w = newFrame.w - delta

        else
            -- Do nothing
            return
        end

        win:setFrame(newFrame)
    end
end

function obj:start()
    hs.hotkey.bind({"ctrl", "option", "cmd"}, 'up', moveFullScreen)
    hs.hotkey.bind({"ctrl", "option", "cmd"}, 'down', moveCenter)
    hs.hotkey.bind({"ctrl", "option", "cmd"}, 'left', moveLeftHalf)
    hs.hotkey.bind({"ctrl", "option", "cmd"}, 'right', moveRightHalf)
    hs.hotkey.bind({"ctrl", "option", "cmd"}, 'l', moveRightHalf)
    hs.hotkey.bind({"ctrl", "option", "cmd"}, 'k', moveCenter)
    hs.hotkey.bind({"ctrl", "option", "cmd"}, 'i', moveFullScreen)
    hs.hotkey.bind({"ctrl", "option", "cmd"}, 'h', moveLeftHalf)
    hs.hotkey.bind({"ctrl", "option", "cmd"}, 'y', moveLeftUpQuarter)
    hs.hotkey.bind({"ctrl", "option", "cmd"}, 'n', moveLeftDownQuarter)
    hs.hotkey.bind({"ctrl", "option", "cmd"}, 'p', moveRightUpQuarter)
    hs.hotkey.bind({"ctrl", "option", "cmd"}, '.', moveRightDownQuarter)
    hs.hotkey.bind({"ctrl", "option", "cmd"}, '[', moveLeftMonitor)
    hs.hotkey.bind({"ctrl", "option", "cmd"}, ']', moveRightMonitor)
    hs.hotkey.bind({"ctrl", "option", "cmd"}, "v", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

    if self.replaceFullscreenWithMaximize then
        self:bindFullScreenMaximize()
    end
end

function obj:stop()
    if self.replaceFullscreenWithMaximize then
        self:unbindFullscreenMaximize()
    end
end

return obj