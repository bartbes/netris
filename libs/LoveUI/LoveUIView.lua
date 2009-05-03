LoveUI.require("LoveUIRect.lua")
LoveUI.require("LoveUIResponder.lua")
LoveUI.View=LoveUI.Responder:new();

function LoveUI.View:init(frame, ...)
	-- e.g local o=LoveUI.Object:alloc():init();
	LoveUI.Responder.init(self, frame, ...);
	self.frame=frame;
	self.scissorFrame=self.frame;
	self.subviews={};
	self.superview=nil;
	self.context=nil;
	self.opaque=false; 
	self.escapeScissor=false;
	self.hidden=false;
	self.backgroundColor=LoveUI.defaultBackgroundColor
	return self;
end

function LoveUI.View:acceptsFirstResponder()
	return true;
end

function LoveUI.View:setFrame(aFrame)
	self.frame=aFrame;
	self:calculateScissor();
end

function LoveUI.View:setOrigin(aPoint)
	self.frame.origin=aPoint:copy();
	self:calculateScissor();
end

function LoveUI.View:setSize(aSize)
	self.frame.size=aSize:copy();
	self:calculateScissor();
end

function LoveUI.View:display()
	--error(tostring(self.class.className()))
	--if self.class.className()=="Button" then error("b") end
	if self.opaque then
		local size=self.frame.size;
		LoveUI.graphics.setColor(self.backgroundColor)
		LoveUI.graphics.rectangle(2, 0, 0, size.width, size.height)
	end
end


function LoveUI.View:toSubviews(fn)
	fn(self);
	for k, v in pairs(self.subviews) do
		fn(v)
		v:toSubviews(fn);
	end
end
function LoveUI.View:update(dt)
	if not self.hidden then
	end
end

function LoveUI.View:convertOriginToBase()
	local p=self.superview:convertPointToBase(self.frame.origin)
	return p.x, p.y;
end

function LoveUI.View:updateSubviews(dt)
	if not self.hidden then
		for k, v in pairs(self.subviews) do
			if not v.hidden then
				LoveUI.pushMatrix()
				LoveUI.translate(v.frame.origin:get())
				v:update(dt);
				v:updateSubviews(dt);
				LoveUI.popMatrix()
			end
		end
	end
end

function LoveUI.View:calculateScissor()
	--if self.superview then
		local super_frame=self:convertRectFromView(self.superview.scissorFrame, self.superview)
		local child_frame=self:convertRectFromView(self.frame, self);
		local x1, y1, x2, y2 = math.max(super_frame.origin.x, 0), math.max(super_frame.origin.y, 0), 
		math.min(super_frame.size.width+super_frame.origin.x, child_frame.size.width), 
		math.min(super_frame.size.height+super_frame.origin.y, child_frame.size.height);
		self.scissorFrame=LoveUI.Rect:new(x1, y1, x2-x1, y2-y1);
		for i, v in ipairs(self.subviews) do
			v:calculateScissor()
		end
	--end
end

function LoveUI.View:getScissor()
	if not self.scissorFrame then
		self:calculateScissor();
	end
	return self.scissorFrame:get();
end

function LoveUI.View:displaySubviews()
	--a View is responsible for drawing itself and subviews
	if not self.hidden then
		for k, v in pairs(self.subviews) do
			if not v.hidden then
				self.context:storeGraphicsEnvironment()
				LoveUI.pushMatrix()
				LoveUI.translate(v.frame.origin:get())
				v:preDisplay()
				--local x, y, w, h=v:getScissor()
				if not v.escapeScissor then
					LoveUI.graphics.setScissor(v:getScissor())
				else
					LoveUI.graphics.setScissor();
				end
				--if  v.escapeScissor or (h>0 and w > 0) then
					v:display();
				
					v:displaySubviews();
				--end
				LoveUI.popMatrix()
				self.context:restoreGraphicsEnvironment()
				v:postDisplay()
			end
		end
	end
end

function LoveUI.View:preDisplay()
end

function LoveUI.View:postDisplay()
end

function LoveUI.View:removeSubview(...)
	local views={...};
	for k, aView in pairs(views) do
		for l, v in pairs(self.subviews) do
			if v==aView then
				table.remove(self.subviews, l);
				aView.superview=nil;
				aView.context=nil;
				aView.nextResponder=nil;
				break;
			end
		end
	end
end

function LoveUI.View:addSubview(...)
	--table.insert(self.subviews, aView);
	local views={...};
	for k, aView in pairs(views) do
		if aView.superview==nil then
			self.subviews[#self.subviews+1]=aView
			aView.superview=self;
			aView.context=self.context;
			aView.nextResponder=self;
			--local subviews={unpack(aView.subviews)};
			--aView:removeSubview(unpack(subviews));
			--aView:addSubview(unpack(subviews));
			aView:toSubviews(function (v) v.context=self.context end)
			aView:calculateScissor();
		else
			LoveUI.error("View to be added already has a super view! It must be removed from its super view's subviews before being added to a view as a subview again! You can copy views by going aView:copy(), which returns a copy")
		end
	end
	
end

function LoveUI.View:lastSubview()
	local lastIndex=#self.subviews;
	while self.subviews[lastIndex].hidden do
		if lastIndex==0 then
			return nil
		end
		lastIndex=lastIndex-1;
	end
	return self.subviews[lastIndex];
end

function LoveUI.View:mouseInRect(aPoint, aRect)
	return LoveUI.mouseInRect(aPoint, aRect) and not self.hidden
end

function LoveUI.View:convertPointToBase(aPoint)
	--each view's origin is in its superview's coord system
	local view=self;
	local x=aPoint.x
	local y=aPoint.y
	while view~=nil do
		x=x+view.frame.origin.x;
		y=y+view.frame.origin.y;
		view=view.superview;
	end
	return LoveUI.Point:new(x, y)
end

function LoveUI.View:convertPointFromBase(aPoint)
	local view=self;
	local x=aPoint.x
	local y=aPoint.y
	while view~=nil do
		x=x-view.frame.origin.x;
		y=y-view.frame.origin.y;
		view=view.superview;
	end
	return LoveUI.Point:new(x, y)
end

function LoveUI.View:convertRectToView(aRect, aView)
	local originThatView=0;
	if aView~=nil then
		originThatView=aView:convertPointFromBase(self:convertPointToBase(aRect.origin));
	else
		originThatView=self:convertPointToBase(aRect.origin);
	end
	return LoveUI.Rect:new(originThatView.x, originThatView.y, aRect.size.width, aRect.size.height);
end

function LoveUI.View:convertRectFromView(aRect, aView)
	local originThisView=0;
	if aView~=nil then
		originThisView=self:convertPointFromBase(aView:convertPointToBase(aRect.origin));
	else
		originThisView=self:convertPointFromBase(aRect.origin);
	end
	return LoveUI.Rect:new(originThisView.x, originThisView.y, aRect.size.width, aRect.size.height);
end

function LoveUI.View:bringToFront()

end