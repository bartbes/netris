--Single Column List View. Single selection can be made
--Basically prototype for table view.
--Once table view made this will be obsolete
LoveUI.require("LoveUIListCell.lua")
LoveUI.ListView=LoveUI.Control:new();

function LoveUI.ListView:init(frame, datasource, ...)
	LoveUI.Control.init(self, frame, ...)
	self.dataSource=datasource;
	self.scrollView=LoveUI.ScrollView:new(LoveUI.Rect:new(0,0,frame.size:get()), LoveUI.Rect:new(0,0,frame.size:get()));
	self:addSubview(self.scrollView)
	self.opaque=true;
	self.cellSpacing=1;
	self.cellHeight=24;
	self.selectedIndex=nil;
	self.controlEvents={}
	self:reloadData()
	
	return self;
end

function LoveUI.ListView:rowAtIndex(index)
	return self.scrollView.contentView.subviews[index];
end

function LoveUI.ListView:reloadData()
	local n=self.dataSource:numberOfRows();
	if self.selectedIndex and (self.selectedIndex>n or self.selectedIndex<1) then
		self.selectedIndex=nil;
	end
	while #self.scrollView.contentView.subviews > 0 do
		self.scrollView.contentView:removeSubview(self.scrollView.contentView.subviews[1]);
	end
	local coluWidth=math.max(self.frame.size.width, self.dataSource:columnWidth());
	
	local i;
	for i=0, n-1, 1 do
		self.scrollView.contentView:addSubview(
			LoveUI.ListCell:new(
				LoveUI.Rect:new(0, i*(self.cellHeight+self.cellSpacing), coluWidth, self.cellHeight), nil, self, i+1))
		self.scrollView.contentView:lastSubview():setContentView(self.dataSource:viewForRow(self, i+1))
		if i%2==1 then
			self.scrollView.contentView:lastSubview().backgroundColor=love.graphics.newColor(128, 128, 255, 32)
		end
	end
	self.scrollView:setContentSize(LoveUI.Size:new(coluWidth, (self.cellHeight+self.cellSpacing)*(n)+5))
	if self.selectedIndex and (self.selectedIndex>n or self.selectedIndex<1) then
		self.selectedIndex=nil;
	end
	self:setSelectedIndex(self.selectedIndex)
end

function LoveUI.ListView:mouseUp(theEvent)
	if theEvent.button==love.mouse_right then
		self:setSelectedIndex(nil);
	else
		if self.nextResponder then
			self.nextResponder:mouseUp(theEvent)
		end
	end
end

function LoveUI.ListView:keyDown(theEvent)
	if theEvent.keyCode==love.key_up then
		if not self.selectedIndex then
			self:setSelectedIndex(self.dataSource:numberOfRows());
		end
		self:setSelectedIndex(self.selectedIndex-1);
		if not self.selectedIndex then
			self:setSelectedIndex(1);
		end
		local f= self:rowAtIndex(self.selectedIndex);
		local x, y, w, h = f:getScissor();
		local fx, fy = f:convertOriginToBase()
		local bx, by=self:convertOriginToBase()
		if h<self.cellHeight and fy > by then
			self.scrollView:addOffset(LoveUI.Point:new(0, h-self.cellHeight+1))
		elseif  h<self.cellHeight then
			self.scrollView:addOffset(LoveUI.Point:new(0, self.cellHeight-h+1))
		end
		return;
	end
	if theEvent.keyCode==love.key_down then
		if not self.selectedIndex then
			self.selectedIndex=1
		end
		self:setSelectedIndex(self.selectedIndex+1);
		if not self.selectedIndex then
			self:setSelectedIndex(self.dataSource:numberOfRows());
		end
		local f= self:rowAtIndex(self.selectedIndex);
		local x, y, w, h = f:getScissor();
		local fx, fy = f:convertOriginToBase()
		local bx, by=self:convertOriginToBase()
		if h<self.cellHeight and fy < by then
			self.scrollView:addOffset(LoveUI.Point:new(0, self.cellHeight-h+3))
		elseif h<self.cellHeight then
			self.scrollView:addOffset(LoveUI.Point:new(0, h-self.cellHeight-3))
		end
		return;
	end
	if self.nextResponder then
		self.nextResponder:keyDown(theEvent)
	end
end

function LoveUI.ListView:setSelectedIndex(index)
	--local origIndex=self.selectedIndex
	if index and (index <1 or index > self.dataSource:numberOfRows()) then
		index=self.selectedIndex
	end
	if self.selectedIndex then
		self.scrollView.contentView.subviews[self.selectedIndex].selected=false;
	end
	
	self.selectedIndex=index;
	if self.selectedIndex then
		self.scrollView.contentView.subviews[self.selectedIndex].selected=true;
	end
	
	--if self.selectedIndex~=origIndex then
		self:activateControlEvent(self, LoveUI.EventDefault ,theEvent, self.selectedIndex);
		self:activateControlEvent(self, LoveUI.EventValueChanged ,theEvent, self.selectedIndex);
	--end
end

function LoveUI.ListView:setAction(anAction, forControlEvent, aTarget)
	if type(anAction)~="function" then
		LoveUI.error("anAction must be a function that is called when event forControlEvent occurs.", 2)
	end
	if forControlEvent==nil then forControlEvent=LoveUI.EventDefault end
	if aTarget then
		self.controlEvents[forControlEvent]=function (...) anAction(aTarget, ...) end ;
	else
		self.controlEvents[forControlEvent]=anAction
	end
end

function LoveUI.ListView:activateControlEvent(sender, forControlEvent, ...)
	
	if self.controlEvents[forControlEvent]~=nil then
		self.controlEvents[forControlEvent](sender, ...);
	end
end

function LoveUI.ListView:getSelectedIndex()
	--returns -1 if no selection
	return self.selectedIndex;
end

--[[
--Datasource methods
function viewForRow
numberOfRows;

columnWidth

]]--
