cols={					-- List of colors
	red = {96,0,0},
	grn = {0,96,0},
	yel = {96,96,0},
	blu = {0,26,96},
	gry = {15,15,15},
	blk = {7,7,7},
	wht = {96,96,96}
	}


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

function drPB (x,y,xs,ys,v,a,pn,pc,bc)							-- progress bar draw function (universal unfinished)
	if bc then													-- "x"  - X coordinate
		setC(bc)												-- "y"  - Y coordinate
		screen.drawRectF(x,y,xs,ys)								-- "xs" - horizontal size
	end															-- "ys" - vertiacal size
		setC(pc)												-- "v" - is vertical? (true/false)
	if v then													-- "a" - alignment (-1 to left/top, 0 center (2 sides), 1 to right\bottom)
		p=math.floor(ys*math.abs(pn))							-- "pn" - progress number (0-1)
		if a == 1 then											-- "pc" - progress color
			screen.drawRectF(x,y,xs,p)							-- "bc" - background color (optional, if nil - no background)
		elseif a == -1 then
			screen.drawRectF(x,y+ys-p,xs,p)
		else
			p=math.floor(((ys/2)-1)*math.abs(pn))
			if xs%2 == 0 then
				if pn <= 0 then
					screen.drawRectF(x,y-1+(ys/2),xs,p+2)
				elseif pn > 0 then
					screen.drawRectF(x,y-1+(ys/2)-p,xs,p+2)
				end
			else
				if pn <= 0 then
					screen.drawRectF(x,y+(ys/2),xs,p+1)
				elseif pn > 0 then
					screen.drawRectF(x,y+(ys/2)-p,xs,p+1)
				end
			end
		end
	else
		p=math.floor(xs*math.abs(pn))
		if a == 1 then
			screen.drawRectF(x,y,p,ys)
		elseif a == -1 then
			screen.drawRectF(x+xs-p,y,p,ys)
		else
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
