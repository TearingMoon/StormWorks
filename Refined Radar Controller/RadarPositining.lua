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
        simulator:setProperty("radarMaxDistance", 5000)
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

ticks = 0
Target1 = { Distance = 0, Azimuth = 0, Elevation = 0, IsDrawing = false, Ticks = 0 };
Target2 = { Distance = 0, Azimuth = 0, Elevation = 0, IsDrawing = false, Ticks = 0 };
Target3 = { Distance = 0, Azimuth = 0, Elevation = 0, IsDrawing = false, Ticks = 0 };
Target4 = { Distance = 0, Azimuth = 0, Elevation = 0, IsDrawing = false, Ticks = 0 };
Target5 = { Distance = 0, Azimuth = 0, Elevation = 0, IsDrawing = false, Ticks = 0 };
Target6 = { Distance = 0, Azimuth = 0, Elevation = 0, IsDrawing = false, Ticks = 0 };
Target7 = { Distance = 0, Azimuth = 0, Elevation = 0, IsDrawing = false, Ticks = 0 };
Target8 = { Distance = 0, Azimuth = 0, Elevation = 0, IsDrawing = false, Ticks = 0 };


function onTick()
    radarSection = property.getNumber("RadarMaxDistanceX") / 3;
    orientation = property.getNumber("Radar Position Adjustment");
    displayZoom = input.getNumber(4); -- Input 4 es el nivel de zoom hasta 3
    currentRadarDisplay = radarSection * displayZoom;
    -- Target 1
    T1ID = input.getBool(1);
    T1Distance = input.getNumber(1);
    T1Azimuth = input.getNumber(2);
    T1Elevation = input.getNumber(3);
    -- Target 2
    T2ID = input.getBool(2);
    T2Distance = input.getNumber(5);
    T2Azimuth = input.getNumber(6);
    T2Elevation = input.getNumber(7);
    -- Target 3
    T3ID = input.getBool(3);
    T3Distance = input.getNumber(9);
    T3Azimuth = input.getNumber(10);
    T3Elevation = input.getNumber(11);
    -- Target 4
    T4ID = input.getBool(4);
    T4Distance = input.getNumber(13);
    T4Azimuth = input.getNumber(14);
    T4Elevation = input.getNumber(15);
    -- Target 5
    T5ID = input.getBool(5);
    T5Distance = input.getNumber(17);
    T5Azimuth = input.getNumber(18);
    T5Elevation = input.getNumber(19);
    -- Target 6
    T6ID = input.getBool(6);
    T6Distance = input.getNumber(21);
    T6Azimuth = input.getNumber(22);
    T6Elevation = input.getNumber(23);
    -- Target 7
    T7ID = input.getBool(7);
    T7Distance = input.getNumber(25);
    T7Azimuth = input.getNumber(26);
    T7Elevation = input.getNumber(27);
    -- Target 8
    T8ID = input.getBool(8);
    T8Distance = input.getNumber(29);
    T8Azimuth = input.getNumber(30);
    T8Elevation = input.getNumber(31);
end

function onDraw()
    h = screen.getHeight();
    w = screen.getWidth();
    centerx = w / 2;
    centery = h / 2;
    radarRadius = centery - h / 12;

    screen.drawTextBox(0, 0, w, h / 12, tostring(displayZoom));

    durationTime = 60 * 5;

    if T1ID then
        Target1 = { Distance = T1Distance, Azimuth = T1Azimuth, Elevation = T1Elevation, Ticks = 0, IsDrawing = true };
    end
    if Target1.IsDrawing then
        Target1.Ticks = Target1.Ticks + 1;
        DrawTarget(Target1.Distance, Target1.Azimuth, Target1.Elevation);
        if (Target1.Ticks > durationTime) then
            Target1.IsDrawing = false;
        end
    end

    if T2ID then
        Target2 = { Distance = T2Distance, Azimuth = T2Azimuth, Elevation = T2Elevation, Ticks = 0, IsDrawing = true };
    end
    if Target2.IsDrawing then
        Target2.Ticks = Target2.Ticks + 1;
        DrawTarget(Target2.Distance, Target2.Azimuth, Target2.Elevation);
        if (Target2.Ticks > durationTime) then
            Target2.IsDrawing = false;
        end
    end

    if T3ID then
        Target3 = { Distance = T3Distance, Azimuth = T3Azimuth, Elevation = T3Elevation, Ticks = 0, IsDrawing = true };
    end
    if Target3.IsDrawing then
        Target3.Ticks = Target3.Ticks + 1;
        DrawTarget(Target3.Distance, Target3.Azimuth, Target3.Elevation);
        if (Target3.Ticks > durationTime) then
            Target3.IsDrawing = false;
        end
    end

    if T4ID then
        Target4 = { Distance = T4Distance, Azimuth = T4Azimuth, Elevation = T4Elevation, Ticks = 0, IsDrawing = true };
    end
    if Target4.IsDrawing then
        Target4.Ticks = Target4.Ticks + 1;
        DrawTarget(Target4.Distance, Target4.Azimuth, Target4.Elevation);
        if (Target4.Ticks > durationTime) then
            Target4.IsDrawing = false;
        end
    end

    if T5ID then
        Target5 = { Distance = T5Distance, Azimuth = T5Azimuth, Elevation = T5Elevation, Ticks = 0, IsDrawing = true };
    end
    if Target5.IsDrawing then
        Target5.Ticks = Target5.Ticks + 1;
        DrawTarget(Target5.Distance, Target5.Azimuth, Target5.Elevation);
        if (Target5.Ticks > durationTime) then
            Target5.IsDrawing = false;
        end
    end

    if T6ID then
        Target6 = { Distance = T6Distance, Azimuth = T6Azimuth, Elevation = T6Elevation, Ticks = 0, IsDrawing = true };
    end
    if Target6.IsDrawing then
        Target6.Ticks = Target6.Ticks + 1;
        DrawTarget(Target6.Distance, Target6.Azimuth, Target6.Elevation);
        if (Target6.Ticks > durationTime) then
            Target6.IsDrawing = false;
        end
    end

    if T7ID then
        Target7 = { Distance = T7Distance, Azimuth = T7Azimuth, Elevation = T7Elevation , Ticks = 0, IsDrawing = true };
    end
    if Target7.IsDrawing then
        Target7.Ticks = Target7.Ticks + 1;
        DrawTarget(Target7.Distance, Target7.Azimuth, Target7.Elevation);
        if (Target7.Ticks > durationTime) then
            Target7.IsDrawing = false;
        end
    end

    if T8ID then
        Target8 = { Distance = T8Distance, Azimuth = T8Azimuth, Elevation = T8Elevation , Ticks = 0 , IsDrawing = true };
    end
    if Target8.IsDrawing then
        Target8.Ticks = Target8.Ticks + 1;
        DrawTarget(Target8.Distance, Target8.Azimuth, Target8.Elevation);
        if (Target8.Ticks > durationTime) then
            Target8.IsDrawing = false;
        end
    end
end

function DrawTarget(Distance, Azimuth, Elevation)
    if (Distance < currentRadarDisplay) then
        radarCorrection = 0.25
        if orientation == 0 then
            radarCorrection = 0.25
        elseif orientation == 1 then
            radarCorrection = -0.25
        elseif orientation == 2 then
            radarCorrection = 0.5
        elseif orientation == 3 then
            radarCorrection = 0
        end

        local DistanceRadius = (radarRadius / currentRadarDisplay) * Distance;
        local AngleInRads = (Azimuth - radarCorrection) * 2 * math.pi;
        local x = centerx + DistanceRadius * math.cos(AngleInRads);
        local y = centery + DistanceRadius * math.sin(AngleInRads);
        screen.setColor(255, 0, 0);
        screen.drawCircleF(x, y, 1);
    end
end
