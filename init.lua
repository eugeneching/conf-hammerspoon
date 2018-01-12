local cmd = {"cmd"}
local cmdShift = {"cmd", "shift"}
local mash = {"cmd", "alt", "ctrl"}
local hyper = {"cmd", "alt", "ctrl", "shift"}

hs.window.animationDuration = 0

require("hs.application")
require("hs.window")


-----------------------------------------------
-- Utilities
-----------------------------------------------

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


-----------------------------------------------
-- Window movement
-----------------------------------------------

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
            local nextScreen = win:screen():previous()
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
            local nextScreen = win:screen():next()
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


-----------------------------------------------
-- Window focus switcher
-----------------------------------------------

function switchWindowByKey()
    hs.hints.windowHints()
end

-----------------------------------------------
-- Key bindings
-----------------------------------------------

hs.hotkey.bind(mash, 'i', moveFullScreen)
hs.hotkey.bind(mash, 'h', moveLeftHalf)
hs.hotkey.bind(mash, 'l', moveRightHalf)
hs.hotkey.bind(mash, 'y', moveLeftUpQuarter)
hs.hotkey.bind(mash, 'n', moveLeftDownQuarter)
hs.hotkey.bind(mash, 'p', moveRightUpQuarter)
hs.hotkey.bind(mash, '.', moveRightDownQuarter)

hs.hotkey.bind(mash, '[', growShrinkToLeft)
hs.hotkey.bind(mash, ']', growShrinkToRight)

hs.hotkey.bind(mash, 'space', switchWindowByKey)

-----------------------------------------------
-- Launcher
-----------------------------------------------

hs.hotkey.bind(cmd, 'f3', function() hs.application.launchOrFocus('calendar') end)
hs.hotkey.bind(cmd, 'f5', function() hs.application.launchOrFocus('path finder') end)
hs.hotkey.bind(cmd, 'f6', function() hs.application.launchOrFocus('sourcetree') end)
hs.hotkey.bind(cmd, 'f7', function() hs.application.launchOrFocus('iterm') end)
hs.hotkey.bind(cmd, 'f8', function() hs.application.launchOrFocus('sublime text') end)
hs.hotkey.bind(cmd, 'f9', function() hs.application.launchOrFocus('google chrome') end)
hs.hotkey.bind(cmdShift, 'f9', function() hs.application.launchOrFocus('google chrome canary') end)

-----------------------------------------------
-- Reload config
-----------------------------------------------

function reload_config(files)
    hs.reload()
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show("config loaded")

