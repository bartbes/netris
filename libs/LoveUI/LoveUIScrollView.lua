--[[
Guide to LoveUI.ScrollView.

Properties:
	--Property
		--[Example Values] description
		
	hidden
		[true/false] set false to hide and disable scrollView
	enabled
		[true/false] whether to enable scrollBars
	opaque
		[true/false] whether to draw blackground
	backgroundColor
	
	setOffset(aPoint)
	
	addOffset(aPoint)
	
	setFrame(aFrame)
		to change origin, size of scrollView
	setSize(aSize)
]]--

LoveUI.require("LoveUIView.lua")
LoveUI.require("LoveUIClipView.lua")
LoveUI.require("LoveUIScroller.lua");

LoveUI.ScrollView=LoveUI.View:new();

function LoveUI.ScrollView:init(frame, contentSize, ...)
	LoveUI.View.init(self, frame, ...)
	self.contentView=LoveUI.View:new(LoveUI.Rect:new(0, 0, contentSize:get()));
	self.scrollbarWidth=15;
	
	self.opaque=true;
	
	self.enabled=true
	
	self:remakeClipView()
	
	self.horizontalScroller=nil;
	self.verticalScroller=nil;
	
	self.horizontalScrollerHidden=false
	self.verticalScrollerHidden=false;
	
	if self:needsHorizontalScroller() then
		self:setHorizontalScroller()
	end
	if self:needsVerticalScroller() then
		self:setVerticalScroller()
	end
	return self;
end

function LoveUI.ScrollView:remakeClipView()
	
	local clipFrame=LoveUI.Rect:new(self.frame:get());
	if self:needsHorizontalScroller() then
		clipFrame.size.height=clipFrame.size.height-self.scrollbarWidth
	end
	if self:needsVerticalScroller() then
		clipFrame.size.width=clipFrame.size.width-self.scrollbarWidth
	end
	clipFrame.origin.y=0
	clipFrame.origin.x=0
	self.clipView=LoveUI.ClipView:new(clipFrame);
	self.clipView:addSubview(self.contentView);
	self:addSubview(self.clipView);
	
	LoveUI.bind(self.clipView, "opaque", self, "opaque",
		function (isopaque) 
			return isopaque
		end
	,	function(isopaque, value)
			self.opaque=value;
		end);
end

function LoveUI.ScrollView:setContentSize(contentSize)
	self.contentView.frame.size=contentSize:copy();
	
	self.clipView:setOffset(LoveUI.Point:new(0,0))
	self.clipView:removeSubview(self.contentView);
	self:removeSubview(self.clipView);
	
	self:remakeClipView()
	self.horizontalScroller=nil;
	self.verticalScroller=nil;
	if self:needsHorizontalScroller() then
		self:setHorizontalScroller()
	end
	if self:needsVerticalScroller() then
		self:setVerticalScroller()
	end
	if self.superview then
		self:calculateScissor();
	end
		
end

function LoveUI.ScrollView:hideHorizontalScroller()
	self.horizontalScrollerHidden=true
	self:setFrame(self.frame);
end

function LoveUI.ScrollView:hideVerticalScroller()
	self.horizontalScrollerHidden=true
	self:setFrame(self.frame);
end

function LoveUI.ScrollView:showHorizontalScroller()
	self.horizontalScrollerHidden=false
	self:setFrame(self.frame);
end

function LoveUI.ScrollView:showVerticalScroller()
	self.horizontalScrollerHidden=false
	self:setFrame(self.frame);
end


function LoveUI.ScrollView:setFrame(frame)
	self.frame=frame;
	self.clipView:setOffset(LoveUI.Point:new(0,0))
	self.clipView:removeSubview(self.contentView);
	self:removeSubview(self.clipView);
	
	self:remakeClipView()
	self.horizontalScroller=nil;
	self.verticalScroller=nil;
	if self:needsHorizontalScroller() then
		self:setHorizontalScroller()
	end
	if self:needsVerticalScroller() then
		self:setVerticalScroller()
	end
	if self.superview then
		self:calculateScissor();
	end
end

function LoveUI.ScrollView:setSize(aSize)
	self:setFrame(LoveUI.Rect:new(self.frame.origin:get(), aSize:get()));
end


function LoveUI.ScrollView:setOffset(aPoint)
	if self.verticalScroller then
		self.verticalScroller:setValue(-aPoint.y/(self.contentView.frame.size.height-self.frame.size.height));
		self.clipView:setOffset(LoveUI.Point:new(self.clipView.offset.x, -self.verticalScroller:getValue()*(self.contentView.frame.size.height-self.frame.size.height)));
	end
	if self.horizontalScroller then
		self.horizontalScroller:setValue(-aPoint.x/(self.contentView.frame.size.width-self.frame.size.width));
		self.clipView:setOffset(LoveUI.Point:new(-self.horizontalScroller:getValue()*(self.contentView.frame.size.width-self.frame.size.width), self.clipView.offset.y));
	end

end

function LoveUI.ScrollView:addOffset(aPoint)
	local aPoint=self.clipView.offset+aPoint
	self:setOffset(aPoint)
end

function LoveUI.ScrollView:display()
	if self.opaque then
		LoveUI.graphics.setColor(self.backgroundColor)
		LoveUI.graphics.rectangle(2, self.frame:get())
	end
end

function LoveUI.ScrollView:postDisplay()
	--After displaying subviews
		LoveUI.graphics.setColor(0,0,0)
		LoveUI.graphics.rectangle(1, self.frame:get())
end


function LoveUI.ScrollView:acceptsFirstResponder()
	return true;
end

function LoveUI.ScrollView:mouseDown(anEvent)
	if anEvent.button==love.mouse_wheeldown and self.verticalScroller and self.enabled then
		local originalValue=self.verticalScroller:getValue()
		local newScrollerValue=-(self.clipView.offset.y-10)/(self.contentView.frame.size.height-self.frame.size.height);
		self.verticalScroller:setValue(newScrollerValue);
		self.clipView:setOffset(LoveUI.Point:new(self.clipView.offset.x, -self.verticalScroller:getValue()*(self.contentView.frame.size.height-self.frame.size.height)));
		if self.verticalScroller:getValue()==originalValue then
			if self.nextResponder then
				self.nextResponder:mouseDown(anEvent)
			end
			return
		end
		
	end
	if anEvent.button==love.mouse_wheelup and self.verticalScroller and self.enabled then
		local originalValue=self.verticalScroller:getValue()
		local newScrollerValue=-(self.clipView.offset.y+10)/(self.contentView.frame.size.height-self.frame.size.height);
		self.verticalScroller:setValue(newScrollerValue);
		self.clipView:setOffset(LoveUI.Point:new(self.clipView.offset.x, -self.verticalScroller:getValue()*(self.contentView.frame.size.height-self.frame.size.height)));
		if self.verticalScroller:getValue()==originalValue then
			if self.nextResponder then
				self.nextResponder:mouseDown(anEvent)
			end
			return
		end
	end
end

function LoveUI.ScrollView:needsHorizontalScroller()
	return (self.contentView.frame.size.width > self.frame.size.width) and not self.horizontalScrollerHidden
end

function LoveUI.ScrollView:needsVerticalScroller()
	return (self.contentView.frame.size.height > self.frame.size.height) and not self.verticalScrollerHidden
end

function LoveUI.ScrollView:setHorizontalScroller()
	self:removeSubview(self.horizontalScroller);
	self:removeSubview(self.verticalScroller);
	
	local clipSize=self.clipView:getContentSize();
	
	local horizHandleLength;
	
	horizHandleLength=self.frame.size.width*self.frame.size.width/clipSize.width;
	if self:needsVerticalScroller() then
		horizHandleLength=self.frame.size.width*(self.frame.size.width-self.scrollbarWidth)/clipSize.width;
	end
	local vertHandleLength
	vertHandleLength=self.frame.size.height*self.frame.size.height/clipSize.height;
	if self:needsHorizontalScroller() then
		vertHandleLength=self.frame.size.height*(self.frame.size.height-self.scrollbarWidth)/clipSize.height;
	end
	if self.verticalScroller then
		self.horizontalScroller=LoveUI.Scroller:new(LoveUI.Point:new(0, self.frame.size.height-self.scrollbarWidth), self.frame.size.width-self.scrollbarWidth, horizHandleLength, self.scrollbarWidth, false);
		
		self.verticalScroller=LoveUI.Scroller:new(LoveUI.Point:new(self.frame.size.width-self.scrollbarWidth, 0), self.frame.size.height-self.scrollbarWidth, vertHandleLength, self.scrollbarWidth, true);
		self:addSubview(self.horizontalScroller, self.verticalScroller)
	else
		self.horizontalScroller=LoveUI.Scroller:new(LoveUI.Point:new(0, self.frame.size.height-self.scrollbarWidth), self.frame.size.width, horizHandleLength, self.scrollbarWidth, false);
		self:addSubview(self.horizontalScroller)
	end
	
	if self.horizontalScroller then
		self.horizontalScroller:setAction(self.horizontalScrolled, LoveUI.EventDefault, self); 
		LoveUI.bind(self.horizontalScroller, "enabled", self, "enabled",
			function (isenabled) 
				return isenabled
			end
		,	function(isenabled, value)
				return nil;
			end);
	end
	if self.verticalScroller then
		self.verticalScroller:setAction(self.verticalScrolled, LoveUI.EventDefault, self); 
		LoveUI.bind(self.verticalScroller, "enabled", self, "enabled",
			function (isenabled) 
				return isenabled
			end
		,	function(isenabled, value)
				return nil;
			end);
	end
end


function LoveUI.ScrollView:setVerticalScroller()
	self:removeSubview(self.horizontalScroller);
	self:removeSubview(self.verticalScroller);
	
	local clipSize=self.clipView:getContentSize();
	local horizHandleLength=self.frame.size.width*self.frame.size.width/clipSize.width;
	horizHandleLength=self.frame.size.width*self.frame.size.width/clipSize.width;
	if self:needsVerticalScroller() then
		horizHandleLength=self.frame.size.width*(self.frame.size.width-self.scrollbarWidth)/clipSize.width;
	end
	local vertHandleLength
	vertHandleLength=self.frame.size.height*self.frame.size.height/clipSize.height;
	if self:needsHorizontalScroller() then
		vertHandleLength=self.frame.size.height*(self.frame.size.height-self.scrollbarWidth)/clipSize.height;
	end
	if self.horizontalScroller then
		self.horizontalScroller=LoveUI.Scroller:new(LoveUI.Point:new(0, self.frame.size.height-self.scrollbarWidth), self.frame.size.width-self.scrollbarWidth, horizHandleLength, self.scrollbarWidth, false);
		
		self.verticalScroller=LoveUI.Scroller:new(LoveUI.Point:new(self.frame.size.width-self.scrollbarWidth, 0), self.frame.size.height-self.scrollbarWidth, vertHandleLength, self.scrollbarWidth, true);
		self:addSubview(self.horizontalScroller, self.verticalScroller)
	else
		self.verticalScroller=LoveUI.Scroller:new(LoveUI.Point:new(self.frame.size.width-self.scrollbarWidth, 0), self.frame.size.height, vertHandleLength, self.scrollbarWidth, true);
		self:addSubview(self.verticalScroller)
	end
	if self.horizontalScroller then
		self.horizontalScroller:setAction(self.horizontalScrolled, LoveUI.EventDefault, self); 
		LoveUI.bind(self.horizontalScroller, "enabled", self, "enabled",
			function (isenabled) 
				return isenabled
			end
		,	function(isenabled, value)
				return nil;
			end);
	end
	if self.verticalScroller then
		self.verticalScroller:setAction(self.verticalScrolled, LoveUI.EventDefault, self); 
		LoveUI.bind(self.verticalScroller, "enabled", self, "enabled",
			function (isenabled) 
				return isenabled
			end
		,	function(isenabled, value)
				return nil;
			end);
	end
end

function LoveUI.ScrollView:horizontalScrolled(sender, event, value)
	local o=0
	if self.verticalScroller then
		o=self.scrollbarWidth
	end
	self.clipView:setOffset(LoveUI.Point:new(-value*(self.contentView.frame.size.width-self.frame.size.width+o), self.clipView.offset.y))
end

function LoveUI.ScrollView:verticalScrolled(sender, event, value)
	local o=0
	if self.horizontalScroller then
		o=self.scrollbarWidth
	end
	
	self.clipView:setOffset(LoveUI.Point:new(self.clipView.offset.x, -value*(self.contentView.frame.size.height-self.frame.size.height+o)))
end

function LoveUI.ScrollView:removeScrollers()
	self:removeSubview(self.horizontalScroller);
	self:removeSubview(self.verticalScroller);
	self.horizontalScroller=nil;
	self.verticalScroller=nil;
end
