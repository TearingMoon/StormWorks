-- Author: Tearing
-- GitHub: <GithubLink>
-- Workshop: <WorkshopLink>
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
    simulator:setScreen(1, "3x3")
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
        simulator:setInputBool(31, simulator:getIsClicked(1)) -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputNumber(2, simulator:getSlider(1))   -- set input 31 to the value of slider 1

        simulator:setInputBool(32, simulator:getIsToggled(2)) -- make button 2 a toggle, for input.getBool(32)
        simulator:setInputNumber(6, simulator:getSlider(2))   -- set input 32 to the value from slider 2 * 50
    end;
end
---@endsection


--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!

function onTick()
    displayedData = {
        Distance = input.getNumber(1),
        Azimuth = input.getNumber(2),
        Elevation = input.getNumber(3),
        SelectedEntity =
            input.getNumber(4),
        RadarDisplay = input.getNumber(5)
    };
    northOffset = input.getNumber(6);

    ULR = property.getNumber("Ultra Long Range");
    LR = property.getNumber("Long Range");
    MR = property.getNumber("Medium Range");
    SR = property.getNumber("Short Range");
    SSR = property.getNumber("Super Short Range");

    entityDurationTime = property.getNumber("Entity representation time");
end

function onDraw()
    w = screen.getWidth();
    h = screen.getHeight();
    boxHeight = h / 5;
    screen.setColor(0, 255, 0);
    screen.drawTextBox(0, 0, w, boxHeight, "Target:" .. tostring(math.floor(displayedData.SelectedEntity)), 0);
    screen.drawTextBox(0, boxHeight, w, boxHeight, "Distance:" .. tostring(math.floor(displayedData.Distance)), 0);
    NorthRads = northOffset * math.pi;
    EntityRads = displayedData.Azimuth * math.pi;
    AngleToNorth = math.fmod((EntityRads - NorthRads), (2 * math.pi));
    AngleToNorth = math.deg(AngleToNorth);
    screen.drawTextBox(0, boxHeight * 2, w, boxHeight, "Angle from N:" .. tostring(math.floor(AngleToNorth)), 0);
    altitude = displayedData.Distance * math.tan((displayedData.Elevation * math.pi));
    screen.drawTextBox(0, boxHeight * 3, w, boxHeight, "Altitude:" .. tostring(math.floor(altitude)), 0);
    visibleRange = ""
    if displayedData.Distance > SSR then
        if displayedData.Distance > SR then
            if displayedData.Distance > MR then
                if displayedData.Distance > LR then
                    visibleRange = "ULR";
                else
                    visibleRange = "LR";
                end
            else
                visibleRange = "MR";
            end
        else
            visibleRange = "SR";
        end
    elseif displayedData.Distance == 0 then
        visibleRange = ""
    else
        visibleRange = "SSR";
    end

    screen.drawTextBox(0, boxHeight * 4, w, boxHeight, "Visible on:" .. visibleRange, 0);
end
