local BaseSpoon = require "Util/BaseSpoon"
local Window    = require "Util/Window"
local Point     = require "Util/Point"
local Math     = require "Util/Math"
local obj = BaseSpoon.new()

obj.name = "WindowMouseSnapping"
obj.version = "1.0"
obj.author = "Eugene Ching"

obj.mouseEvents = {
    ['leftMouseDragged'] = "onMouseDrag",
    ['leftMouseUp'] = "onMouseUp"
}

obj.activeEvents = {}
obj.windowTitlebarHeight = 21
obj.monitorEdgeSensitivity = 100
obj.isDragging = false
obj.draggedWin = nil
obj.draggedWinFrame = nil

function moveFullScreenMouse()
    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local target = {
            x = hs.mouse.getCurrentScreen():frame().x,
            y = hs.mouse.getCurrentScreen():frame().y,
            w = hs.mouse.getCurrentScreen():frame().w,
            h = hs.mouse.getCurrentScreen():frame().h
        }

        move(target)
    end
end

function moveLeftHalfMouse()
    local factor = 2

    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local target = {
            x = hs.mouse.getCurrentScreen():frame().x,
            y = hs.mouse.getCurrentScreen():frame().y,
            w = hs.mouse.getCurrentScreen():frame().w/factor,
            h = hs.mouse.getCurrentScreen():frame().h
        }

        move(target)
    end
end

function moveRightHalfMouse()
    local factor = 2

    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local target = {
            x = hs.mouse.getCurrentScreen():frame().x + hs.mouse.getCurrentScreen():frame().w/factor,
            y = hs.mouse.getCurrentScreen():frame().y,
            w = hs.mouse.getCurrentScreen():frame().w/factor,
            h = hs.mouse.getCurrentScreen():frame().h
        }

        move(target)
    end
end

function moveLeftUpQuarterMouse()
    local factor = 2

    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local target = {
            x = hs.mouse.getCurrentScreen():frame().x,
            y = hs.mouse.getCurrentScreen():frame().y,
            w = hs.mouse.getCurrentScreen():frame().w/factor,
            h = hs.mouse.getCurrentScreen():frame().h/factor
        }

        move(target)
    end
end

function moveLeftDownQuarterMouse()
    local factor = 2

    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local target = {
            x = hs.mouse.getCurrentScreen():frame().x,
            y = hs.mouse.getCurrentScreen():frame().y + hs.mouse.getCurrentScreen():frame().h/factor,
            w = hs.mouse.getCurrentScreen():frame().w/factor,
            h = hs.mouse.getCurrentScreen():frame().h/factor
        }

        move(target)
    end
end

function moveRightUpQuarterMouse()
    local factor = 2

    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local target = {
            x = hs.mouse.getCurrentScreen():frame().x + hs.mouse.getCurrentScreen():frame().w/factor,
            y = hs.mouse.getCurrentScreen():frame().y,
            w = hs.mouse.getCurrentScreen():frame().w/factor,
            h = hs.mouse.getCurrentScreen():frame().h/factor
        }

        move(target)
    end
end

function moveRightDownQuarterMouse()
    local factor = 2

    if hs.window.focusedWindow() then
        local win = hs.window.focusedWindow()
        local target = {
            x = hs.mouse.getCurrentScreen():frame().x + hs.mouse.getCurrentScreen():frame().w/factor,
            y = hs.mouse.getCurrentScreen():frame().y + hs.mouse.getCurrentScreen():frame().h/factor,
            w = hs.mouse.getCurrentScreen():frame().w/factor,
            h = hs.mouse.getCurrentScreen():frame().h/factor
        }

        move(target)
    end
end


-- Method to be called when a mouse drag event
function obj:onMouseDrag()
    if not self.isDragging then
        local win = Window.getActiveWindow()

        if win ~= nil then
            local mouse = hs.mouse.getAbsolutePosition()
            local mouseCoords = hs.geometry.new({x = Math.round(mouse.x), y = Math.round(mouse.y)})
            local winFrame = win:frame()

            if mouseCoords:inside(winFrame) then
                self.isDragging = true
                self.draggedWin = win
                self.draggedWinFrame = winFrame
            end
        end
    end
end

-- Method to be called when the mouse "click" is released. This method is a no-op
-- unless we previously recorded that the mouse was dragging.
function obj:onMouseUp()
    if self.isDragging then
        local mouse = hs.mouse.getAbsolutePosition()
        local mouseCoords = hs.geometry.new({x = Math.round(mouse.x), y = Math.round(mouse.y)})
        local win = Window.getActiveWindow()
        local screenFrame = hs.mouse.getCurrentScreen():frame()

        if not self.draggedWinFrame:equals(win:frame()) and Point.isAtEdge(mouseCoords, screenFrame, self.monitorEdgeSensitivity) then
            self:applySnap(win, mouseCoords, screenFrame)
        end
    end
    self.isDragging = false
    self.draggedWin = nil
    self.currentMousePositionInWindow = nil
end

-- Apply the snap to the window. This method will calculate the appropriate height, width, and coordinates
-- of window origin and apply them to the window.
function obj:applySnap(win, coords, frame)
    local newWinFrame = hs.geometry.copy(frame)
    local isTop = false
    local isBottom = false
    local isLeft = false
    local isRight = false

    if Point.isAtLeft(coords, frame, self.monitorEdgeSensitivity) then
        isLeft = true
    end

    if Point.isAtRight(coords, frame, self.monitorEdgeSensitivity) then
        isRight = true
    end

    if Point.isAtTop(coords, frame, self.monitorEdgeSensitivity) then
        isTop = true
    end

    if Point.isAtBottom(coords, frame, self.monitorEdgeSensitivity) then
        isBottom = true
    end

    if isTop and isLeft then moveLeftUpQuarterMouse()
    elseif isTop and isRight then moveRightUpQuarterMouse()
    elseif isBottom and isLeft then moveLeftDownQuarterMouse()
    elseif isBottom and isRight then moveRightDownQuarterMouse()
    elseif isLeft then moveLeftHalfMouse()
    elseif isRight then moveRightHalfMouse()
    else moveFullScreenMouse()
    end
end

function obj:start()
    -- For OSX event timing issues, we need to hook in after _some_ animation.
    if hs.window.animationDuration == 0 then
        hs.window.animationDuration = 0.00000001
    end
end

function obj:stop()
    for index, event in ipairs(self.activeEvents) do
        event:stop()
    end
    self.activeEvents = {}
end

return obj