-- Point Utils
-- ------------
-- This module provides utility methods that pertain to a specific point/coordinate on the screen. It
-- should be used with an `hs.geometry` object with x and y values.

local Point = {}

Point.isAtMap = {
    top    = function(point, frame, margin) return (point.y - frame.y <= margin) end,
    bottom = function(point, frame, margin) return (point.y >= frame.h - margin) end,
    left   = function(point, frame, margin) return (point.x >= frame.x and point.x < frame.x + margin) end,
    right  = function(point, frame, margin) return (point.x <= frame.x+frame.w and point.x > frame.x+frame.w - margin) end
}

function Point.isAt(point, frame, margin, spot)
    return Point.isAtMap[spot](point, frame, margin)
end

-- Named methods for specifity edge checking
function Point.isAtTop(point, frame, withinMargin)
    return Point.isAt(point, frame, withinMargin, "top")
end

function Point.isAtBottom(point, frame, withinMargin)
    return Point.isAt(point, frame, withinMargin, "bottom")
end

function Point.isAtLeft(point, frame, withinMargin)
    return Point.isAt(point, frame, withinMargin, "left")
end

function Point.isAtRight(point, frame, withinMargin)
    return Point.isAt(point, frame, withinMargin, "right")
end

function Point.isAtEdge(point, frame, withinMargin)
    return Point.isAtTop(point, frame, withinMargin) or
           Point.isAtBottom(point, frame, withinMargin) or
           Point.isAtRight(point, frame, withinMargin) or
           Point.isAtLeft(point, frame, withinMargin)
end

-- Calculate the relative point coordinates within a frame
function Point.getRelativeCoords(point, frame)
    return hs.geometry.new({
        x = point.x - frame.x,
        y = point.y - frame.y
    })
end

return Point