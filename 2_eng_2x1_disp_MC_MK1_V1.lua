t=1						-- timer
wrn=false				-- warning light state trigger

cols={					-- List of colors
	red = {96,0,0},
	grn = {0,96,0},
	yel = {96,96,0},
	blu = {0,26,96},
	gry = {15,15,15},
	blk = {7,7,7},
	wht = {96,96,96}
	}


function onTick()
	inStr = input.getNumber(9)
	inTrtl1 = input.getNumber(10)
	inTrtl2 = input.getNumber(11)	
	inRps1 = input.getNumber(12)
	inRps2 = input.getNumber(13)
	inRpsYel = input.getNumber(14)
	inRpsRed = input.getNumber(15)
	inRpmS = input.getBool(16)
	inTemp1 = input.getNumber(17)
	inTemp2 = input.getNumber(18)
	inTempNrm = input.getNumber(19)
	inTempRed = input.getNumber(20)
	inTempWarn = input.getNumber(21)
	inSpd = input.getNumber(22)
	inMaxSpd = input.getNumber(23)
	inFuel = input.getNumber(24)
	inFuelMax = input.getNumber(25)
	inFuelRed = input.getNumber(26)
    inFuelWarn = input.getNumber(27)
	inCon = input.getNumber(28)
	inConS = input.getNumber(29)
	inTC = input.getNumber(30)

	cp={									-- right bottom field variant list
		{"l/s",inCon,3},
		{"l/min",inCon*60,5},
		{"l/h",inCon*3600,6},
		{"m/s",inSpeed,3},
		{"kph",math.floor(inSpd * 3.6),3},
		{"mph",math.floor(inSpd * 2.24),3},
		{"knots",math.floor(inSpd * 1.94),5}
		}

end

function onDraw()
	tp =  math.floor(60/inTC)			-- warning light trigger timer
	if t>=0 and t<=tp/2 then
		wrn=true
		t = t+1
	elseif t>tp/2 and t<tp then
		wrn=false
		t = t+1
	else t=0
	end

	setC("gry")							-- background color
	screen.drawRectF(0,0,64,32)

	drPBHC(3,0,58,1,inStr,"red","blk")										-- steering bar
	
	drPBVU(0,0,2,17,inTrtl1,"grn","blk")									-- trottle eng 1 bar
	drPBVU(62,0,2,17,inTrtl2,"grn","blk") 									-- trottle eng 1 bar

	selCol(inRps1,nil,inRpsYel,inRpsRed,"grn","yel","red")					-- rps/rpm 1 engine color
	if inRpmS then
		drTB(3,2,inRps1*60,1,4,selC,"blk")									-- rpm 1 engine
	else
		drTB(3,2,inRps1,1,3,selC,"blk",2)									-- rps 1 engine
	end

	selCol(inRps1,inRps2,inRpsYel,inRpsRed,"grn","yel","red")				-- "rps/rpm" text color
	if inRpmS then
		drTB(22,2,"RPM",0,4,selC)
	else
		drTB(22,2,"RPS",0,4,selC)
	end

	selCol(inRps2,nil,inRpsYel,inRpsRed,"grn","yel","red")					-- rps/rpm 2 engine color
	if inRpmS then
		drTB(40,2,inRps2*60,-1,4,selC,"blk")								-- rpm 2 engine
	else
		drTB(43,2,inRps2,-1,3,selC,"blk",2)									-- rps 2 engine
	end

	selCol(inTemp1,nil,inTempNrm,inTempRed,"yel","grn","red",inTempWrn) 	-- temperature 1 engine color
	drTB(3,10,inTemp1,1,3,selC,"blk",2)															

	selCol(inTemp1,inTemp2,inTempNrm,inTempRed,"yel","grn","red",inTempWrn)	-- temperature text color
	drTB(22,10,"temp",0,4,selC)
	
	selCol(inTemp2,nil,inTempNrm,inTempRed,"yel","grn","red",inTempWrn)		-- temperature 2 engine color
	drTB(43,10,inTemp2,-1,3,selC,"blk",2)

	if inFuelMax <= 9999 then			--Fuel text field size
		xs = 4
	elseif inFuelMax <= 99999 then
		xs = 5
	else 
		xs = 6
	end
	selCol(inFuel,nil,nil,-inFuelMax*inFuelRed/100,"yel",nil,"red",-inFuelMax*inFuelWarn/100)	-- Fuel gauge color
	drTB(3,18,"Fuel",0,xs,selC)																	-- Fuel text
	drTB(3,25,inFuel,0,xs,selC,"blk")															-- Fuel gauge
	drPBVU(0,18,2,14,inFuel/inFuelMax,selC,"blk")											-- Fuel bar

	if inConS ~= 0 then
		if inConS <= 3 then															-- consumtion/speed position and color
			x=65
			scol="yel"
		else
			x=61
			scol="blu"
			drPBVU(62,18,2,14,inSpd/inMaxSpd,scol,"blk")							-- speed bar 
		end
		drTB(x-(cp[inConS][3]*5+1),18,cp[inConS][1],0,cp[inConS][3],scol)			-- consumption/speed text
		drTB(x-(cp[inConS][3]*5+1),25,cp[inConS][2],0,cp[inConS][3],scol,"blk")		-- consumption/speed gauge
	end


end

function setC(col,a)													--set color function
	if a == nil then
		a=255
	end
	if cols[col] then
		screen.setColor(cols[col][1],cols[col][2],cols[col][3],a)
	else
		print("no color")			--debug string
		screen.setColor(96,96,96,a) --backup default color
	end		
end

function drTB(x,y,t,ax,cn,tc,bc,to)					-- textbar draw function with optional background. X size defined by character number and offset, Y size fixed 7
	if bc then										-- "x"  - X coordinate, 
		setC(bc)									-- "y"  - Y coordinate of field
		if to then									-- "t"  - text, numbers automaticaly floored.
			screen.drawRectF(x,y,cn*5+1+to,7)		-- "ta" - text alignment (-1 left, 0 center, 1 right)
		else										-- "cn" - max character number (define field x size),
			screen.drawRectF(x,y,cn*5+1,7)			-- "tc" - text color,
		end											-- "bc" - background color (optional, if not defined - no background),
	end												-- "to" - text offset (from left or right side, defined by alignment, not work for 0) (optional, if not defined, than 0)
	if tc then
		setC(tc)
	else 
		setC("wht")
	end
	if ax == -1 then
		x = x+1
		to = 0
	end
	if to and type(t) == "number" then
		screen.drawTextBox(x+to,y+1,cn*5,5,math.floor(t),ax,0)
	elseif type(t) == "number" then
		screen.drawTextBox(x,y+1,cn*5,5,math.floor(t),ax,0)
	elseif to then
		screen.drawTextBox(x+to,y+1,cn*5,5,t,ax,0)
	else
		screen.drawTextBox(x,y+1,cn*5,5,t,ax,0)	
	end
end

function selCol(tNum1,tNum2,mNum,hNum,lCol,mCol,hCol,wNum)									-- color set function, checks 2 numbers (optional) with 3 predefined levels (optional)
	if wrn and wNum and wNum<0 and (tNum1 < -wNum or (tNum2 and tNum2 < -wNum)) then		-- "tNum1", "tNum2" - numbers to check, second is optional, can be "nil"
		if mCol then																		-- "mNum" - first triger level (optional, must exist if mCol not nil)
			selC=mCol																		-- "hNum" - second triger level (positive trigers if tNum bigger than hNum, negative trigger if tNum smaller than hNum)
		else																				-- "lCol" - standard, pretrigered color
			selC=lCol																		-- "mCol" - first triger color (optional)
		end																					-- "hCol" - second triger color
	elseif wrn and wNum and wNum>0 and (tNum1 > wNum or (tNum2 and tNum2 > wNum)) then		-- "wNum" - warning triger level, will blink between mCol and hCol if mCol exist, else lCol and hCol ->
		if mCol then																		-- -> (optional, positive trigers if tNum bigger than wNum, negative trigger if tNum smaller than wNum)
			selC=mCol
		else
			selC=lCol
		end
	elseif mCol and mNum then
		if hNum < 0 and tNum1 <= -hNum or (tNum2 and tNum2 <= -hNum) then
			selC = hCol
		elseif hNum < 0 and (tNum1 <= -mNum and tNum1 > -hNum) or (tNum2 and tNum2 <= -mNum and tNum2 > -hNum) then
			selC = mCol
		elseif tNum1 >= hNum or (tNum2 and tNum2 >= hNum) then
			selC = hCol
		elseif (tNum1 >= mNum and tNum1 < hNum) or (tNum2 and tNum2 >= mNum and tNum2 < hNum) then
			selC = mCol
		else
			selC = lCol
		end
	else
		if hNum < 0 and tNum1 < -hNum then
			selC = hCol
		elseif hNum > 0 and tNum1 > hNum then
			selC = hCol
		else
			selC = lCol
		end
	end
end

function drPBVU (x,y,xs,ys,pn,pc,bc)							-- Vertical from bottom to top progress bar draw function:
	if bc then													-- "x"  - X coordinate, "y"  - Y coordinate,
		setC(bc)												-- "xs" - horizontal size, "ys" - vertiacal size
		screen.drawRectF(x,y,xs,ys)								-- "pn" - progress number (0-1), "pc" - progress color
	end															-- "bc" - background color (optional, if nil - no background)
	setC(pc)
	p=math.floor(ys*math.abs(pn))
	screen.drawRectF(x,y+ys-p,xs,p)
end
function drPBHC (x,y,xs,ys,pn,pc,bc)							-- Horizontal from center to sides progress bar draw function:
	if bc then													-- "x"  - X coordinate, "y"  - Y coordinate,
		setC(bc)												-- "xs" - horizontal size, "ys" - vertiacal size
		screen.drawRectF(x,y,xs,ys)								-- "pn" - progress number (0-1), "pc" - progress color
	end															-- "bc" - background color (optional, if nil - no background)
	p=math.floor(((xs/2)-1)*math.abs(pn))
	if xs%2 == 0 then
		if pn >= 0 then
			screen.drawRectF(x-1+(xs/2),y,p+2,ys)
		elseif pn < 0 then
			screen.drawRectF(x-1+(xs/2)-p,y,p+2,ys)
		end
	else
		if pn >= 0 then
			screen.drawRectF(x+(xs/2),y,p+1,ys)
		elseif pn < 0 then
			screen.drawRectF(x+(xs/2)-p,y,p+1,ys)
		end
	end
end
