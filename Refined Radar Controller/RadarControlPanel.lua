-- Author: Tearing
-- GitHub: https://github.com/TearingMoon
-- Workshop: https://steamcommunity.com/profiles/76561198215821583/myworkshopfiles/
--
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
    simulator:setScreen(1, "3x1")
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
but1IsPressed = false;
but2IsPressed = false;
but3IsPressed = false;
but4IsPressed = false;
function onTick()
    isPressed = input.getBool(1);
    touchX = input.getNumber(3);
    touchY = input.getNumber(4);

    output.setBool(1, but1IsPressed);
    output.setBool(2, but2IsPressed);
    output.setBool(3, but3IsPressed);
    output.setBool(4, but4IsPressed);
end

function onDraw()
    w = screen.getWidth();
    h = screen.getHeight();

    buttonWidth = w / 2 - 3;
    buttonheight = h / 2 - 3;
    leftButtonStartX = 1;
    rightButtonStartX = w - buttonWidth - 2;
    upButtonStartY = 1;
    downButtonStartY = h - buttonheight - 2;
    but1IsPressed = false;
    but2IsPressed = false;
    but3IsPressed = false;
    but4IsPressed = false;


    if isPressed and (touchX > leftButtonStartX and touchX < leftButtonStartX + buttonWidth) and (touchY > upButtonStartY and touchY < upButtonStartY + buttonheight) then
        but1IsPressed = true;
    end

    if isPressed and (touchX > leftButtonStartX and touchX < leftButtonStartX + buttonWidth) and (touchY > downButtonStartY and touchY < downButtonStartY + buttonheight) then
        but2IsPressed = true;
    end

    if isPressed and (touchX > rightButtonStartX and touchX < rightButtonStartX + buttonWidth) and (touchY > upButtonStartY and touchY < upButtonStartY + buttonheight) then
        but3IsPressed = true;
    end

    if isPressed and (touchX > rightButtonStartX and touchX < rightButtonStartX + buttonWidth) and (touchY > downButtonStartY and touchY < downButtonStartY + buttonheight) then
        but4IsPressed = true;
    end

    screen.setColor(0, 255, 255);
    if but1IsPressed then
        screen.setColor(255, 255, 0);
    end
    screen.drawRect(leftButtonStartX, upButtonStartY, buttonWidth, buttonheight);
    screen.drawTextBox(leftButtonStartX, upButtonStartY + 1, buttonWidth, buttonheight, "Range", 0);
    screen.drawTextBox(leftButtonStartX, upButtonStartY + buttonheight / 2, buttonWidth, buttonheight, "UP", 0);

    screen.setColor(255, 0, 255);
    if but2IsPressed then
        screen.setColor(255, 255, 0);
    end
    screen.drawRect(leftButtonStartX, downButtonStartY, buttonWidth, buttonheight);
    screen.drawTextBox(leftButtonStartX, downButtonStartY + 1, buttonWidth, buttonheight, "Range", 0);
    screen.drawTextBox(leftButtonStartX, downButtonStartY + buttonheight / 2, buttonWidth, buttonheight, "DOWN", 0);

    screen.setColor(0, 255, 0);
    if but3IsPressed then
        screen.setColor(255, 255, 0);
    end
    screen.drawRect(rightButtonStartX, upButtonStartY, buttonWidth, buttonheight);
    screen.drawTextBox(rightButtonStartX, upButtonStartY + 1, buttonWidth, buttonheight, "Prev", 0);
    screen.drawTextBox(rightButtonStartX, upButtonStartY + buttonheight / 2, buttonWidth, buttonheight, "target", 0);

    screen.setColor(0, 255, 0);
    if but4IsPressed then
        screen.setColor(255, 255, 0);
    end
    screen.drawRect(rightButtonStartX, downButtonStartY, buttonWidth, buttonheight);
    screen.drawTextBox(rightButtonStartX, downButtonStartY + 1, buttonWidth, buttonheight, "Next", 0);
    screen.drawTextBox(rightButtonStartX, downButtonStartY + buttonheight / 2, buttonWidth, buttonheight, "target", 0);
end

function drawControls()

end
