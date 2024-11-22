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



-- This microcontroller controls the vertical alignment of a gun and a camera
_verticalCameraAxis = 0;
_verticalGunAxis = 0;
_selectedWeapon = property.getNumber("Weapon");
_prevChasisTilt = 0;
function onTick()
    -- Get Number variables
    userInput = input.getNumber(1);
    chasisTilt = input.getNumber(2);
    cameraZoom = input.getNumber(4);
    laserDistance = input.getNumber(5);
    
    -- Get Bool variables
    isStabilizing = input.getBool(1);
    isTelemeter = input.getBool(2);
    isInverted = input.getBool(3);
    
    -- local variables
    maxVerticalSpeed = 0.5;
    minVerticalSpeed = 0.05;
    chasisDeltaTilt = chasisTilt - _prevChasisTilt;

    ManageVerticalAxis();

    -- Outputing Data
    output.setNumber(1, 0)                                  -- Horizontal Camera tilt
    output.setNumber(2, _verticalCameraAxis - computedTilt) -- Vertical Camera tilt
    output.setNumber(3, _verticalGunAxis - computedTilt)    -- Gun

    --Saving previous tick tilt (For Delta calculations)
    _prevChasisTilt = chasisTilt;
end

function ManageVerticalAxis()
    movementSpeed = ((1 - cameraZoom) * maxVerticalSpeed + (cameraZoom * minVerticalSpeed));
    if isStabilizing then
        computedTilt = ((chasisTilt + chasisDeltaTilt) * 8); -- 8 for the gear ratio of the rotor
    else
        computedTilt = 0;
    end
    computedBearing = movementSpeed * userInput;
    _verticalCameraAxis = (_verticalCameraAxis + computedBearing / 100);
end
