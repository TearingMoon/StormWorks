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
        simulator:setInputBool(31, simulator:getIsClicked(1))       -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputNumber(1, simulator:getSlider(1));
        simulator:setInputNumber(2, simulator:getSlider(2));
        simulator:setInputNumber(3, simulator:getSlider(3));

        simulator:setInputBool(32, simulator:getIsToggled(2))       -- make button 2 a toggle, for input.getBool(32)
    end;
end
---@endsection


--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!

ticks = 0

function onTick()
    radarPosition = input.getNumber(1);
    orientation = input.getNumber(2);
    compassPos = input.getNumber(3);
end

function onDraw()
	w = screen.getWidth();
	h = screen.getHeight();
	circleRadius = h/2 - h/12;
	circleW = w/2;
	circleH = h/2;
	
	screen.setColor(2,2,2);
	screen.drawRectF(0,0,w,h);
	
	drawCompass();
	
	drawBackground(8,5);
	
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
	
	drawRadarLine(1,20)
end

function drawBackground(sections, divisions)
	screen.setColor(0,255,0)
	screen.drawCircleF(circleW, circleH, circleRadius + 1);
	screen.setColor(0,0,0);
	screen.drawCircleF(circleW, circleH, circleRadius);
	screen.setColor(0,255,0);
	screen.drawCircle(circleW, circleH, circleRadius);
	screen.setColor(0,255,0, 30);
	for i = 1, sections do
		sectionAngle = (i - 1) * (2 * math.pi / sections);
    	x = circleW + (circleRadius) * math.cos(sectionAngle);
    	y = circleH + (circleRadius) * math.sin(sectionAngle);
		screen.drawLine(circleW, circleH, x, y );
	end
	for i = 1, divisions do
		screen.drawCircle(circleW, circleH, circleRadius / divisions * i);
	end
end

function drawRadarLine(traceAngle, triangles)
	local radarAngle = (radarPosition - radarCorrection) * 2 * math.pi;
	local x = circleW + circleRadius * math.cos(radarAngle);
	local y = circleH + circleRadius * math.sin(radarAngle);
	
	local angleOverload = traceAngle / triangles;
	local x1 = x;
	local y1 = y;
	
	for i = 1, triangles do
		local x2 = circleW + (circleRadius) * math.cos(radarAngle - (angleOverload * i));
		local y2 = circleH + (circleRadius) * math.sin(radarAngle - (angleOverload * i));
		screen.setColor(0,255,0, 100 - (100 / triangles) * i);
		screen.drawTriangleF(circleW, circleH , x1, y1, x2, y2)
		x1 = x2
		y1 = y2
	end
	screen.setColor(0,255,0);
	screen.drawLine(circleW, circleH, x, y );
end

function drawCompass()
	screen.setColor(255,0,0)
	compassAngle = compassPos * 2 * math.pi;
	local cx1 = circleW + (circleRadius + h/12) * math.cos(compassAngle);
	local cy1 = circleH + (circleRadius + h/12) * math.sin(compassAngle);
	local cx2 = circleW + (circleRadius) * math.cos(compassAngle - 0.2);
	local cy2 = circleH + (circleRadius) * math.sin(compassAngle - 0.2);
	local cx3 = circleW + (circleRadius) * math.cos(compassAngle + 0.2);
	local cy3 = circleH + (circleRadius) * math.sin(compassAngle + 0.2);
	screen.drawTriangleF(cx1,cy1,cx2,cy2,cx3,cy3);

	for i = 1, 40 do
		screen.setColor(255,0,0, 50)
		sectionAngle = compassAngle + (i - 1) * (2 * math.pi / 40) + (2 * math.pi / 40);
		local lenght = h/12 * 0.5;
		if math.fmod(i, 5) == 0 then
			screen.setColor(255,0,0, 100);
			lenght = h/12;
		end
    	x = circleW + (circleRadius+lenght) * math.cos(sectionAngle);
    	y = circleH + (circleRadius+lenght) * math.sin(sectionAngle);
		screen.drawLine(circleW, circleH, x, y );
	end
	
	screen.setColor(255,255,255)
	local cx1 = circleW + -(circleRadius + h/12) * math.cos(compassAngle);
	local cy1 = circleH + -(circleRadius + h/12) * math.sin(compassAngle);
	local cx2 = circleW + -(circleRadius) * math.cos(compassAngle - 0.2);
	local cy2 = circleH + -(circleRadius) * math.sin(compassAngle - 0.2);
	local cx3 = circleW + -(circleRadius) * math.cos(compassAngle + 0.2);
	local cy3 = circleH + -(circleRadius) * math.sin(compassAngle + 0.2);
	screen.drawTriangleF(cx1,cy1,cx2,cy2,cx3,cy3);
end



