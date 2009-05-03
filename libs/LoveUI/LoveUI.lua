--love.filesystem.require("Library/class.lua");
do
	LoveUI={};
	LoveUI.images={};
	LoveUI.sounds={};
	
	LoveUI.graphics={};
	LoveUI.mouse={};
	
	for k, v in pairs(love.graphics) do
		LoveUI.graphics[k]=v;
	end
	
	for k, v in pairs(love.mouse) do
		LoveUI.mouse[k]=v;
	end
	
	
	local LIBRARY_NAME="LoveUI";
	
	function LoveUI.error(message, level)
		-- custom error function
		-- if level is 1, then console will show the function that called LoveUI.error
		if level==nil then level= 1 end;
		error(LIBRARY_NAME.." library: "..message, 2+level);
	end
	
	function LoveUI:getImage(imageName)
		if self.images[imageName]~= nil then
			return self.images[imageName]
		end
		local imagePath="libs/LoveUI/images/"..imageName
		self.images[imageName] = LoveUI.graphics.newImage(imagePath)
		return self.images[imageName]
	end
	
	--Constants:
	LoveUI.MOUSE=1;
	LoveUI.KEY=1;
	LoveUI.OFF=0;
	LoveUI.ON=1;
	LoveUI.DEFAULTFONT=LoveUI.graphics.newFont(love.default_font, 12)
	LoveUI.DEFAULT_FONT=LoveUI.DEFAULTFONT
	LoveUI.SMALLFONT=LoveUI.graphics.newFont(love.default_font, 10)
	LoveUI.SMALL_FONT=LoveUI.SMALLFONT
	
	
	
	LoveUI.defaultBackgroundColor=LoveUI.graphics.newColor(255, 255, 255);
	LoveUI.defaultForegroundColor=LoveUI.graphics.newColor(64, 64, 192);
	LoveUI.defaultSecondaryColor=LoveUI.graphics.newColor(0, 0, 128);
	
	--Control Events
	LoveUI.EventDefault=1;
	LoveUI.EventMouseEntered=2; --Deprecated.
	LoveUI.EventMouseExited=3; --Deprecated.
	LoveUI.EventMouseClicked=4;
	LoveUI.EventTextHasChanged=5;
	LoveUI.EventValueChanged=5;
	
	--Basic Functions
	LoveUI.time = function()
		-- return milliseconds since start up
		return love.timer.getTime( )*1000;
	end
	
	LoveUI.mouseInRect = function (aPoint, aRect)
		return 
			aPoint.x >= aRect.origin.x and
			aPoint.y >= aRect.origin.y and
			aPoint.x <= aRect.origin.x + aRect.size.width and
			aPoint.y <= aRect.origin.y + aRect.size.height;	
	end
	
	LoveUI.require=function(fileName)
		love.filesystem.require("libs/LoveUI/"..fileName);
	end
	LoveUI.copy=function(aTable)
		local cpy={};
		for k, v in pairs(aTable) do
			cpy[k]=v;
		end
		return cpy;
	end
	LoveUI.requireall=function(dir)
		love.filesystem.require(dir.."/LoveUIContext.lua");
		love.filesystem.require(dir.."/LoveUIClipView.lua");
		love.filesystem.require(dir.."/LoveUITextfield.lua");
		love.filesystem.require(dir.."/LoveUIButton.lua");
		love.filesystem.require(dir.."/LoveUIScrollView.lua");
		love.filesystem.require(dir.."/LoveUIListView.lua");
	end
	LoveUI.pushMatrix = function()
		local matrix={}
		matrix.graphics={}
		matrix.graphics.draw=LoveUI.graphics.draw
		matrix.graphics.draws=LoveUI.graphics.draws
		matrix.drawf=LoveUI.graphics.drawf
		matrix.graphics.point=LoveUI.graphics.point
		matrix.graphics.line=LoveUI.graphics.line
		matrix.graphics.triangle=LoveUI.graphics.triangle
		matrix.graphics.rectangle=LoveUI.graphics.rectangle
		matrix.graphics.quad=LoveUI.graphics.quad
		matrix.graphics.circle=LoveUI.graphics.circle
		matrix.graphics.polygon=LoveUI.graphics.polygon
		matrix.graphics.setScissor=LoveUI.graphics.setScissor
		matrix.graphics.getScissor=LoveUI.graphics.getScissor
		
		matrix.mouse={}
		matrix.mouse.getX=LoveUI.mouse.getX;
		matrix.mouse.getY=LoveUI.mouse.getY;
		matrix.mouse.getPosition=LoveUI.mouse.getPosition
		matrix.mouse.setPosition=LoveUI.mouse.setPosition
		LoveUI.graphicsMatrixStack:push(matrix);
	end
	
	LoveUI.popMatrix = function()
		local matrix=LoveUI.graphicsMatrixStack:pop();
		LoveUI.graphics.draw=matrix.graphics.draw
		LoveUI.graphics.draws=matrix.graphics.draws
		LoveUI.graphics.drawf=matrix.graphics.drawf
		LoveUI.graphics.point=matrix.graphics.point
		LoveUI.graphics.line=matrix.graphics.line
		LoveUI.graphics.triangle=matrix.graphics.triangle
		LoveUI.graphics.rectangle=matrix.graphics.rectangle
		LoveUI.graphics.quad=matrix.graphics.quad
		LoveUI.graphics.circle=matrix.graphics.circle
		LoveUI.graphics.polygon=matrix.graphics.polygon
		LoveUI.graphics.setScissor=matrix.graphics.setScissor
		LoveUI.graphics.getScissor=matrix.graphics.getScissor
		
		LoveUI.mouse.getX=matrix.mouse.getX;
		LoveUI.mouse.getY=matrix.mouse.getY;
		LoveUI.mouse.getPosition=matrix.mouse.getPosition
		LoveUI.mouse.setPosition=matrix.mouse.setPosition
	end
	LoveUI.translate = function(translate_x, translate_y)
		--In future hopefully replace with OpenGL's translate
		local d=LoveUI.graphics.draw;
		LoveUI.graphics.draw=function(subject, x, y, ...)
			d(subject, x+translate_x, y+translate_y, ...)
		end
		
		local df=LoveUI.graphics.drawf;
		LoveUI.graphics.drawf=function(subject, x, y, ...)
			df(subject, x+translate_x, y+translate_y, ...)
		end
		
		local ds=LoveUI.graphics.draws;
		LoveUI.graphics.draws=function(subject, x, y, ...)
			ds(subject, x+translate_x, y+translate_y, ...)
		end
		
		local dp=LoveUI.graphics.point;
		LoveUI.graphics.point=function(x, y)
			dp(x+translate_x, y+translate_y);
		end
		
		local dl=LoveUI.graphics.line;
		LoveUI.graphics.line=function(x1, y1, x2, y2)
			dl(x1+translate_x, y1+translate_y, x2+translate_x, y2+translate_y);
		end
		
		local dt=LoveUI.graphics.triangle;
		LoveUI.graphics.triangle=function(t, x1, y1, x2, y2, x3, y3)
			dt(t, x1+translate_x, y1+translate_y, x2+translate_x, y2+translate_y, x3+translate_x, y3+translate_y);
		end
		
		local dr=LoveUI.graphics.rectangle;
		LoveUI.graphics.rectangle=function(t, x1, y1, w, h)
			dr(t, x1+translate_x, y1+translate_y, w, h);
		end
		
		local dq=LoveUI.graphics.quad;
		LoveUI.graphics.quad=function(t, x1, y1, x2, y2, x3, y3, x4, y4)
			dq(t, x1+translate_x, y1+translate_y, x2+translate_x, y2+translate_y, x3+translate_x, y3+translate_y, x4+translate_x, y4+translate_y);
		end
		
		local dc=LoveUI.graphics.circle;
		LoveUI.graphics.circle=function(t, x1, y1, ...)
			dc(t, x1+translate_x, y1+translate_y, ...);
		end
		
		local dpoly=LoveUI.graphics.polygon;
		LoveUI.graphics.polygon=function(t, ...)
			local vars={...}
			for k, v in ipairs(vars) do
				if i%2==0 then
					vars[k]=v+translate_x
				else
					vars[k]=v+translate_y
				end
			end
			dpoly(t, unpack(vars));
		end
		
		local dsetSci=LoveUI.graphics.setScissor;
		LoveUI.graphics.setScissor=function(x, y, w, h)
			if not x then
				dsetSci();
			else
				dsetSci(x+translate_x, y+translate_y, w, h);
			end
		end
		
		local dgetSci=LoveUI.graphics.getScissor;
		LoveUI.graphics.getScissor=function()
			local x, y, w, h =dgetSci();
			if not x then return nil; end
			return x-translate_x, y-translate_y, w, h
		end
		
		local dmgetX=LoveUI.mouse.getX;
		LoveUI.mouse.getX=function()
			return dmgetX() - translate_x;
		end
		
		local dmgetY=LoveUI.mouse.getY;
		LoveUI.mouse.getY=function()
			return dmgetY() - translate_y;
		end
		
		local dmgetPos=LoveUI.mouse.getPosition;
		LoveUI.mouse.getPosition=function()
			local x, y= dmgetPos()
			return x- translate_x, y- translate_y;
		end
		
		local dmsetPos=LoveUI.mouse.setPosition;
		LoveUI.mouse.setPosition=function(x, y)
			dmsetPos(x- translate_x, y- translate_y);
		end
		
		
	end

end
LoveUI.require("LoveUIStack.lua");
LoveUI.require("LoveUIRect.lua");
LoveUI.graphicsMatrixStack=LoveUI.Stack:new();
LoveUI.rectZero=LoveUI.Rect:new(0,0,0,0)
