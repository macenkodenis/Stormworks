i=1
j=1
t=1
wrn=false

inpB={
	{inP1,7},
	{inP2,8},
	{inRpmS,16}
	}

cols={
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

	cp={
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
	tp =  math.floor(60/inTC)
	if t>=0 and t<=tp/2 then
		wrn=true
		t = t+1
	elseif t>tp/2 and t<tp then
		wrn=false
		t = t+1
	else t=0
	end

	setC("gry")
	screen.drawRectF(0,0,64,32)

	drPB(3,0,58,1,false,0,inStr,"red","blk")
	
	drPB(0,0,2,17,true,-1,inTrtl1,"grn","blk")
	drPB(62,0,2,17,true,-1,inTrtl2,"grn","blk")

	selCol(inRps1,nil,inRpsYel,inRpsRed,"grn","yel","red")
	if inRpmS then
		drTB(3,2,inRps1*60,1,4,selC,"blk")
	else
		drTB(3,2,inRps1,1,3,selC,"blk",2)
	end

	selCol(inRps1,inRps2,inRpsYel,inRpsRed,"grn","yel","red")
	if inRpmS then
		drTB(22,2,"RPM",0,4,selC)
	else
		drTB(22,2,"RPS",0,4,selC)
	end

	selCol(inRps2,nil,inRpsYel,inRpsRed,"grn","yel","red")
	if inRpmS then
		drTB(40,2,inRps2*60,-1,4,selC,"blk")
	else
		drTB(43,2,inRps2,-1,3,selC,"blk",2)
	end

	selCol(inTemp1,nil,inTempNrm,inTempRed,"yel","grn","red",inTempWrn)
	drTB(3,10,inTemp1,1,3,selC,"blk",2)

	selCol(inTemp1,inTemp2,inTempNrm,inTempRed,"yel","grn","red",inTempWrn)
	drTB(22,10,"temp",0,4,selC)
	
	selCol(inTemp2,nil,inTempNrm,inTempRed,"yel","grn","red",inTempWrn)
	drTB(43,10,inTemp2,-1,3,selC,"blk",2)

	if inFuelMax <= 9999 then
		xs = 4
	elseif inFuelMax <= 99999 then
		xs = 5
	else 
		xs = 6
	end
	selCol(inFuel,nil,nil,-inFuelMax*inFuelRed/100,"yel",nil,"red",-inFuelMax*inFuelWarn/100)
	drTB(3,18,"Fuel",0,xs,selC)
	drTB(3,25,inFuel,0,xs,selC,"blk")
	drPB(0,18,2,14,true,-1,inFuel/inFuelMax,selC,"blk")

	if inConS <= 3 then
		x=65
		scol="yel"
	else
		x=61
		scol="blu"
		drPB(62,18,2,14,true,-1,inSpd/inMaxSpd,scol,"blk")
	end
	drTB(x-(cp[inConS][3]*5+1),18,cp[inConS][1],0,cp[inConS][3],scol)
	drTB(x-(cp[inConS][3]*5+1),25,cp[inConS][2],0,cp[inConS][3],scol,"blk")

end

function setC(col,a)
	if a == nil then
		a=255
	end
	if cols[col] then
		screen.setColor(cols[col][1],cols[col][2],cols[col][3],a)
	else
		print("no color")
		screen.setColor(96,96,96,a)
	end		
end

function drTB(x,y,t,ax,cn,tc,bc,to)
	if bc then
		setC(bc)
		if to then
			screen.drawRectF(x,y,cn*5+1+to,7)
		else
			screen.drawRectF(x,y,cn*5+1,7)
		end
	end
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

function selCol(tNum1,tNum2,mNum,hNum,lCol,mCol,hCol,wNum)
	if wrn and wNum and wNum<0 and (tNum1 < -wNum or (tNum2 and tNum2 < -wNum)) then
		if mCol then
			selC=mCol
		else
			selC=lCol
		end
	elseif wrn and wNum and wNum>0 and (tNum1 > wNum or (tNum2 and tNum2 > wNum)) then
		if mCol then
			selC=mCol
		else
			selC=lCol
		end
	elseif mCol then
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

function drPB (x,y,xs,ys,v,a,pn,pc,bc)
	if bc then
		setC(bc)
		screen.drawRectF(x,y,xs,ys)
	end
		setC(pc)
	if v then
		p=math.floor(ys*math.abs(pn))
		if a == 1 then
			screen.drawRectF(x,y,xs,p)
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
