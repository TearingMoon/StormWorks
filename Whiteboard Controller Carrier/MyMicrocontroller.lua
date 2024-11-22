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

MAX_AIRCRAFT = 10
CURRENT_AIRCRAFTS = 0
id = 0
selected_id = false
aircrafts = {}
new_craft_type = 1
drawings = { function(a, b) f35(a, b) end, function(a, b) heli(a, b) end, function(a, b) vt(a, b) end }
i = input
IPN = i.getNumber
IPB = i.getBool
S = screen
SC = S.setColor
DL = S.drawLine
DTF = S.drawTriangleF
DRF = S.drawRectF
DR = S.drawRect
DC = S.drawCircle
function onTick()
    _x = IPN(3)
    _y = IPN(4)
    tch = IPB(1) and not justPressed
    justPressed = IPB(1)
    add_more = tch
        and gordo(_x, _y, 1, 1, 5, 5)
    del_airc = tch
        and gordo(_x, _y, 6, 1, 5, 5)
    change_t = tch
        and gordo(_x, _y, 15, 1, 30, 5)
    moveAircraft(_x, _y, tch, add_more, del_airc)
    if change_t then
        new_craft_type = new_craft_type + 1
        if new_craft_type > #drawings then
            new_craft_type = 1
        end
    end
    if add_more and CURRENT_AIRCRAFTS < MAX_AIRCRAFT and not del_airc then
        CURRENT_AIRCRAFTS = CURRENT_AIRCRAFTS + 1
        id = id + 1
        aircrafts[id] = createAircraft(20 + CURRENT_AIRCRAFTS * 4, 20 + CURRENT_AIRCRAFTS * 5, new_craft_type)
        add_more = false
    end
    if del_airc and CURRENT_AIRCRAFTS > 0 and selected_id and not add_more then
        aircrafts[selected_id] = nil
        selected_id = false
        CURRENT_AIRCRAFTS = CURRENT_AIRCRAFTS - 1
        del_airc = false
    end
    if id >= 999 then
        id = 0
    end
end

function moveAircraft(_x, _y, tch, c, d)
    if selected_id and aircrafts[selected_id].moving and tch and not c and not d then
        aircrafts[selected_id].x = _x + 2
        aircrafts[selected_id].y = _y - 9
        aircrafts[selected_id].moving = false
        selected_id = nil
    end
end

function onDraw()
    menu()
    drawAircrafts()
    selectAircraft()
end

function widget(self)
    SC(11, 18, 9)
    DR(self.x + 5 + self.width, self.y, 22, 12)
    SC(18, 31, 15)
    DRF(self.x + 6 + self.width, self.y + 1, 21, 11)
    SC(255, 255, 255, 100)
    txt(self.x + 7 + self.width, self.y + 2, "ID:" .. self._id)
    txt(self.x + 7 + self.width, self.y + 7, "TY:" .. self._t)
end

function createAircraft(a, b, e)
    return {
        x = a,
        y = b,
        _t = e,
        _id = id,
        width = 18,
        height = 18,
        draw = function(self) drawings[self._t](self.x, self.y) end,
        menu = function(self)
            widget(self)
        end,
        moving = false
    }
end

function selectAircraft()
    for f, g in pairs(aircrafts) do
        if TCH(_x, _y, g) then
            SC(160, 160, 160)
            g:menu()
            selected_id = g._id
            g.moving = true
        end
    end
end

function drawAircrafts()
    if CURRENT_AIRCRAFTS > 0 then
        for f, g in pairs(aircrafts) do
            g:draw()
        end
    end
end

function menu()
    SC(11, 18, 9)
    DR(0, 0, 287, 7)
    SC(18, 31, 15)
    DRF(1, 1, 286, 6)
    SC(255, 255, 255, 100)
    txt(2, 1, "+"
    )
    txt(7, 1, "-"
    )
    txt(15, 2, "type: "
        .. new_craft_type)
    txt(52, 2, "Current Aircrafts:"
        .. CURRENT_AIRCRAFTS)
    txt(250, 2, "LeafNav"
    )
    if selected_id then
        txt(140, 2, "S_ID:"
            .. tostring(selected_id))
    end
end

function f35(x, y)
    SC(84, 84, 84)
    DL(20 + x, 16 + y, 30.25 + x, 14.25 + y)
    DL(20 + x, 12 + y, 30.25 + x, 14.25 + y)
    DL(21 + x, 10 + y, 19.25 + x, 12.25 + y)
    DL(19 + x, 16 + y, 21.25 + x, 18.25 + y)
    DL(15 + x, 18 + y, 20.25 + x, 18.25 + y)
    DL(15 + x, 10 + y, 21.25 + x, 10.25 + y)
    DL(11 + x, 27 + y, 14.25 + x, 19.25 + y)
    DL(11 + x, 2 + y, 14.25 + x, 9.25 + y)
    DL(9 + x, 2 + y, 11.25 + x, 2.25 + y)
    DL(9 + x, 27 + y, 11.25 + x, 27.25 + y)
    DL(7 + x, 12 + y, 9.25 + x, 3.25 + y)
    DL(7 + x, 16 + y, 9.25 + x, 27.25 + y)
    DL(4 + x, 7 + y, 7.25 + x, 12.25 + y)
    DL(4 + x, 20 + y, 6.25 + x, 16.25 + y)
    DL(2 + x, 20 + y, 4.25 + x, 20.25 + y)
    DL(0 + x, 16 + y, 2.25 + x, 20.25 + y)
    DL(2 + x, 7 + y, 4.25 + x, 7.25 + y)
    DL(0 + x, 12 + y, 2.25 + x, 7.25 + y)
    DL(0 + x, 12 + y, 6.25 + x, 12.25 + y)
    DL(0 + x, 16 + y, 5.25 + x, 16.25 + y)
    SC(2, 2, 2)
    DC(4 + x, 14 + y, 1)
    SC(108, 108, 108)
    DRF(5 + x, 13.5 + y, 18, 3)
    DRF(8 + x, 6.5 + y, 6, 7)
    DRF(8 + x, 16.5 + y, 6, 8)
    DRF(14 + x, 16.5 + y, 6, 3)
    DRF(14 + x, 10.5 + y, 6, 3)
    DRF(1 + x, 9.5 + y, 5, 3)
    DRF(1 + x, 17.5 + y, 5, 2)
    DRF(3 + x, 19.5 + y, 2, 1)
    DRF(3 + x, 8.5 + y, 2, 1)
    DRF(10 + x, 3.5 + y, 2, 24)
    SC(152, 150, 120)
    DRF(22 + x, 14.5 + y, 6, 1)
    SC(64, 64, 64)
    DL(7 + x, 12 + y, 8.25 + x, 12.25 + y)
    DL(7 + x, 16 + y, 8.25 + x, 16.25 + y)
    DL(9 + x, 17 + y, 15.25 + x, 17.25 + y)
    DL(9 + x, 11 + y, 15.25 + x, 11.25 + y)
    DL(16 + x, 12 + y, 21.25 + x, 13.25 + y)
    DL(21 + x, 15 + y, 16.25 + x, 16.25 + y)
end

function heli(x, y)
    SC(11, 11, 11)
    DRF(16 + x, 13.5 + y, 3, 3)
    DL(29 + x, 2 + y, 19.25 + x, 12.25 + y)
    DL(19 + x, 16 + y, 29.25 + x, 26.25 + y)
    DL(5 + x, 26 + y, 15.25 + x, 16.25 + y)
    DL(5 + x, 2 + y, 15.25 + x, 12.25 + y)
    SC(62, 62, 62)
    DRF(19 + x, 13.5 + y, 12, 3)
    DRF(8 + x, 13.5 + y, 8, 3)
    DL(0 + x, 14 + y, 7.25 + x, 14.25 + y)
    DRF(1 + x, 11.5 + y, 2, 7)
    SC(9, 9, 9)
    DRF(0 + x, 12.5 + y, 4, 1)
    SC(62, 62, 62)
    DL(10 + x, 12 + y, 14.25 + x, 12.25 + y)
    DL(10 + x, 16 + y, 14.25 + x, 16.25 + y)
    DL(16 + x, 16 + y, 18.25 + x, 16.25 + y)
    DL(20 + x, 16 + y, 26.25 + x, 16.25 + y)
    DL(20 + x, 12 + y, 26.25 + x, 12.25 + y)
    DL(16 + x, 12 + y, 18.25 + x, 12.25 + y)
    DL(15 + x, 11 + y, 19.25 + x, 11.25 + y)
    DL(21 + x, 11 + y, 24.25 + x, 11.25 + y)
    DL(12 + x, 11 + y, 13.25 + x, 11.25 + y)
    DL(12 + x, 17 + y, 13.25 + x, 17.25 + y)
    DL(15 + x, 17 + y, 19.25 + x, 17.25 + y)
    DL(21 + x, 17 + y, 24.25 + x, 17.25 + y)
    SC(34, 25, 45)
    DL(24 + x, 12 + y, 26.25 + x, 13.25 + y)
    DL(25 + x, 15 + y, 24.25 + x, 16.25 + y)
    DL(26 + x, 15 + y, 26.25 + x, 15.25 + y)
    SC(22, 22, 22)
    DL(19 + x, 18 + y, 19.25 + x, 19.25 + y)
    DL(18 + x, 19 + y, 20.25 + x, 19.25 + y)
    DL(11 + x, 18 + y, 16.25 + x, 18.25 + y)
    DL(8 + x, 18 + y, 9.25 + x, 16.25 + y)
    SC(11, 11, 11)
    DL(7 + x, 25 + y, 16.25 + x, 16.25 + y)
    DL(19 + x, 15 + y, 27.25 + x, 23.25 + y)
    DL(25 + x, 5 + y, 18.25 + x, 12.25 + y)
    DL(8 + x, 6 + y, 15.25 + x, 13.25 + y)
end

function vt(x, y)
    SC(91, 91, 91)
    DRF(0 + x, 14.5 + y, 32, 3)
    DRF(14 + x, 10.5 + y, 11, 11)
    DL(25 + x, 10 + y, 28.25 + x, 13.25 + y)
    DL(28 + x, 17 + y, 25.25 + x, 20.25 + y)
    DRF(0 + x, 10.5 + y, 3, 11)
    DRF(25 + x, 12.5 + y, 3, 2)
    DRF(25 + x, 17.5 + y, 3, 2)
    DRF(12 + x, 11.5 + y, 14, 9)
    DRF(15 + x, 21.5 + y, 3, 5)
    DRF(0 + x, 9.5 + y, 5, 1)
    DRF(0 + x, 21.5 + y, 5, 1)
    DRF(15 + x, 4.5 + y, 3, 6)
    SC(19, 19, 19)
    DRF(0 + x, 10.5 + y, 1, 11)
    SC(34, 34, 34)
    DRF(16 + x, 26.5 + y, 4, 3)
    DRF(16 + x, 2.5 + y, 4, 3)
    SC(12, 12, 12)
    DL(10 + x, 0 + y, 17.25 + x, 5.25 + y)
    DL(23 + x, 0 + y, 17.25 + x, 5.25 + y)
    DL(17 + x, 5 + y, 18.25 + x, 10.25 + y)
    DL(16 + x, 18 + y, 17.25 + x, 26.25 + y)
    DL(10 + x, 31 + y, 17.25 + x, 26.25 + y)
    DL(17 + x, 26 + y, 25.25 + x, 30.25 + y)
    SC(82, 82, 82)
    DL(15 + x, 5 + y, 15.25 + x, 12.25 + y)
    DL(15 + x, 18 + y, 15.25 + x, 25.25 + y)
    DL(18 + x, 17 + y, 18.25 + x, 20.25 + y)
    DL(19 + x, 17 + y, 28.25 + x, 17.25 + y)
    DL(18 + x, 11 + y, 18.25 + x, 13.25 + y)
    DL(19 + x, 13 + y, 28.25 + x, 13.25 + y)
    DL(19 + x, 18 + y, 24.25 + x, 18.25 + y)
    DL(12 + x, 18 + y, 14.25 + x, 18.25 + y)
    DL(12 + x, 12 + y, 14.25 + x, 12.25 + y)
    DL(19 + x, 12 + y, 24.25 + x, 12.25 + y)
    SC(0, 0, 0)
    DL(14 + x, 19 + y, 14.25 + x, 25.25 + y)
    DL(14 + x, 5 + y, 14.25 + x, 9.25 + y)
    DL(0 + x, 12 + y, 0.25 + x, 18.25 + y)
    DL(28 + x, 16 + y, 27.25 + x, 17.25 + y)
    DL(27 + x, 13 + y, 28.25 + x, 14.25 + y)
    DL(24 + x, 13 + y, 25.25 + x, 13.25 + y)
    DL(24 + x, 17 + y, 25.25 + x, 17.25 + y)
    SC(91, 91, 91)
    DL(9 + x, 13 + y, 11.25 + x, 11.25 + y)
    DL(9 + x, 17 + y, 11.25 + x, 19.25 + y)
    DRF(10 + x, 17.5 + y, 2, 2)
    DRF(10 + x, 12.5 + y, 2, 2)
    DL(3 + x, 17 + y, 9.25 + x, 17.25 + y)
    DL(2 + x, 13 + y, 9.25 + x, 13.25 + y)
    DL(28 + x, 12 + y, 30.25 + x, 13.25 + y)
    DL(29 + x, 17 + y, 30.25 + x, 17.25 + y)
    DL(28 + x, 18 + y, 28.25 + x, 18.25 + y)
end

function TCH(a, b, h)
    return a >= h.x and b >= h.y and a <= h.x + h.width and b <= h.y + h.height
end

function gordo(a, b, j, k, l, m)
    return a >= j and b >= k and a <= j + l and b <= k + m
end

function txt(a, b, n)
    n = tostring(n)
    for i = 1, n:len()
    do
        local o = n:sub(i, i):upper()
            :byte()
            * 3 - 95
        if o > 193 then
            o = o - 78
        end
        o = "0x"
            ..
            string.sub(
            "0000D0808F6F5FAB6D5B7080690096525272120222010168F9F5F1BBD9DBE2FDDBFBB8BCFBFEAF0A01A025055505289C69D7A7FB6699F96FB9FA869BF2F9F921EF69F11FCFF8F696FA4F9EFA55BB8F8F1FE1EF3FD2DC3CBFDF9086109F4841118406F90F09F6642"
            , o, o + 2)
        for p = 0, 11 do
            if o & (1 << 11 - p) > 0 then
                local q = a + p // 4 + i * 4 - 4
                DL(q, b + p % 4, q, b + p % 4 + 1)
            end
        end
    end
end
