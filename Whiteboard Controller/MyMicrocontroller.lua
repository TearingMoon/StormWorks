--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey


--[====[ HOTKEYS ]====]
-- Press F6 to simulate this file
-- Press F7 to build the project, copy the output from /_build/out/ into the game to use
-- Remember to set your Author name etc. in the settings: CTRL+COMMA


--[====[ EDITABLE SIMULATOR CONFIG - *automatically removed from the F7 build output ]====]
---@section __LB_SIMULATOR_ONLY__
do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator
    simulator:setScreen(1, "9x5")
    simulator:setProperty("ExampleNumberProperty", 123)

    -- Runs every tick just before onTick; allows you to simulate the inputs changing
    ---@param simulator Simulator Use simulator:<function>() to set inputs etc.
    ---@param ticks     number Number of ticks since simulator started
    function onLBSimulatorTick(simulator, ticks)
        -- touchscreen defaults
        local screenConnection = simulator:getTouchScreen(1)
        simulator:setInputBool(1, screenConnection.isTouched)
        simulator:setInputNumber(1, screenConnection.width)
        simulator:setInputNumber(2, screenConnection.height)
        simulator:setInputNumber(3, screenConnection.touchX)
        simulator:setInputNumber(4, screenConnection.touchY)

        -- NEW! button/slider options from the UI
        simulator:setInputBool(31, simulator:getIsClicked(1))     -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputNumber(31, simulator:getSlider(1))      -- set input 31 to the value of slider 1

        simulator:setInputBool(32, simulator:getIsToggled(2))     -- make button 2 a toggle, for input.getBool(32)
        simulator:setInputNumber(32, simulator:getSlider(2) * 50) -- set input 32 to the value from slider 2 * 50
    end;
end
---@endsection


--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!

S = screen
SC = S.setColor
DRF = S.drawRectF
DR = S.drawRect
DL = S.drawLine
DTF = S.drawTriangleF

TemporalLine = {
    start = {
        x = 0,
        y = 0,
    },
    finish = {
        x = 0,
        y = 0,
    },
    color = "black"
}

Lines = {}
isDrawingLine = false;
isDeleting = false;
selectedColor = "black"

function onTick()
    -- Getting touchscreen data
    isBeingPressed = input.getBool(1)
    touchX = input.getNumber(3)
    touchY = input.getNumber(4)

    if IsOnRect(274, 6, 281, 13) and isBeingPressed then
        selectedColor = "red"
        isDeleting = false;
    elseif IsOnRect(274, 16, 281, 23) and isBeingPressed then
        selectedColor = "green"
        isDeleting = false;
    elseif IsOnRect(274, 26, 281, 33) and isBeingPressed then
        selectedColor = "blue"
        isDeleting = false;
    elseif IsOnRect(274, 36, 281, 43) and isBeingPressed then
        selectedColor = "black"
        isDeleting = false;
    elseif IsOnRect(274, 46, 281, 53) and isBeingPressed then
        isDeleting = true;
    end

    if not isDeleting then
        Draw()
    elseif isDeleting and isBeingPressed then
        RemoveLine()
    end
end

function onDraw()
    DrawWhiteBoard(0, 0);
    if isDrawingLine then
        DrawLine(TemporalLine.start.x, TemporalLine.start.y, TemporalLine.finish.x, TemporalLine.finish.y, "drawing") -- DrawTemporalLine
    end
    for _, Line in pairs(Lines) do
        DrawLine(Line.start.x, Line.start.y, Line.finish.x, Line.finish.y, Line.color)
    end
end

function DrawWhiteBoard(x, y)
    SC(201, 201, 201)
    DRF(0 + x, 0.5 + y, 288, 160)
    SC(14, 14, 14)
    DR(0 + x, 0 + y, 287, 159)
    DR(1 + x, 1 + y, 285, 157)
    SC(42, 42, 42)
    DR(2 + x, 2 + y, 283, 155)
    DR(3 + x, 3 + y, 281, 153)
    SC(24, 24, 24)
    DL(2 + x, 2 + y, 285.25 + x, 2.25 + y)
    DL(3 + x, 3 + y, 284.25 + x, 3.25 + y)
    SC(64, 64, 64)
    DL(3 + x, 156 + y, 284.25 + x, 156.25 + y)
    DL(2 + x, 157 + y, 285.25 + x, 157.25 + y)
    SC(255, 0, 0)
    DRF(274 + x, 6.5 + y, 8, 8)
    SC(0, 255, 0)
    DRF(274 + x, 16.5 + y, 8, 8)
    SC(0, 0, 255)
    DRF(274 + x, 26.5 + y, 8, 8)
    SC(0, 0, 0)
    DRF(274 + x, 36.5 + y, 8, 8)
    DR(274 + x, 46 + y, 7, 7)
    DL(274 + x, 46 + y, 281.25 + x, 53.25 + y)
    DL(274 + x, 53 + y, 281.25 + x, 46.25 + y)
    DRF(278 + x, 59.5 + y, 4, 2)
    DTF(278 + x, 63.5 + y, 278 + x, 56.5 + y, 274 + x, 59.5 + y)
    DRF(274 + x, 69.5 + y, 4, 2)
    DTF(277 + x, 66.5 + y, 277 + x, 73.5 + y, 281 + x, 69.5 + y)
    DL(271 + x, 4 + y, 271.25 + x, 155.25 + y)
end

function DrawLine(startx, starty, finishx, finishy, color)
    if color == "black" then
        SC(0, 0, 0)
        DL(startx, starty, finishx, finishy)
    elseif color == "green" then
        SC(0, 255, 0)
        DL(startx, starty, finishx, finishy)
    elseif color == "red" then
        SC(255, 0, 0)
        DL(startx, starty, finishx, finishy)
    elseif color == "blue" then
        SC(0, 0, 255)
        DL(startx, starty, finishx, finishy)
    elseif color == "drawing" then
        SC(250, 128, 114)
        DL(startx, starty, finishx, finishy)
    end
end

function Draw()
    -- if not isDrawingLine and isBeingPressed then
    --     isDrawingLine = true;
    --     TemporalLine.start.x = touchX;
    --     TemporalLine.start.y = touchY;
    --     TemporalLine.finish.x = touchX;
    --     TemporalLine.finish.y = touchY;
    -- end

    -- if isDrawingLine then
    --     TemporalLine.finish.x = touchX;
    --     TemporalLine.finish.y = touchY;
    -- end

    -- if not isBeingPressed and isDrawingLine then
    --     newData = {
    --         start = {
    --             x = TemporalLine.start.x,
    --             y = TemporalLine.start.y,
    --         },
    --         finish = {
    --             x = TemporalLine.finish.x,
    --             y = TemporalLine.finish.y,
    --         },
    --         color = selectedColor
    --     }
    --     table.insert(Lines, newData)
    --     isDrawingLine = false;
    -- end

    if not isDrawingLine and isBeingPressed then
        isDrawingLine = true;
        TemporalLine.start.x = touchX;
        TemporalLine.start.y = touchY;
        TemporalLine.finish.x = touchX;
        TemporalLine.finish.y = touchY;
    elseif isDrawingLine and isBeingPressed then
        newData = {
            start = {
                x = TemporalLine.start.x,
                y = TemporalLine.start.y,
            },
            finish = {
                x = touchX,
                y = touchY,
            },
            color = selectedColor
        }
        table.insert(Lines, newData)
        isDrawingLine = false;
    end
end

function IsOnRect(x1, y1, x2, y2)
    return x1 < touchX and x2 > touchX and y1 < touchY and y2 > touchY
end

function RemoveLine()
    for _, Line in pairs(Lines) do
        if IsOnSegment(Line.start.x, Line.start.y, Line.finish.x, Line.finish.y, touchX, touchY) then
            table.remove(Lines, _)
        end
    end
end

function IsOnSegment(x1, y1, x2, y2, px, py)
    if not IsOnLine(x1, y1, x2, y2, px, py) then
        return false
    end
    local minX, maxX = math.min(x1, x2), math.max(x1, x2)
    local minY, maxY = math.min(y1, y2), math.max(y1, y2)
    return (px >= minX and px <= maxX) and (py >= minY and py <= maxY)
end

function IsOnLine(x1, y1, x2, y2, px, py)
    local m = (y2 - y1) / (x2 - x1)
    local b = y1 - m * x1
    return py == m * px + b
end
