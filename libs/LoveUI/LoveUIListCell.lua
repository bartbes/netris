LoveUI.ListCell=LoveUI.View:new();

function LoveUI.ListCell:init(frame, contentView, theListView, index, ...)
	LoveUI.View.init(self, frame, ...)
	self.listView=theListView;
	self.contentView=contentView;
	self.index=index;
	self:addSubview(contentView);
	self.selected=false;
	self.enabled=true;
	self.opaque=true
	return self;
end

function LoveUI.ListCell:display()
	LoveUI.View.display(self);
	if self.selected then
		if self.enabled then
			LoveUI.graphics.setColor(50,50,255,128);
		else
			LoveUI.graphics.setColor(50,50,50,32);
		end
		LoveUI.graphics.rectangle(2, 0,0,self.frame.size:get())
	end
end

function LoveUI.ListCell:setContentView(aView)
	if self.subviews[1] then
		self.removeSubview(self.subviews[1])
	end
	--aView=aView:copy();
	self:addSubview(aView);
	self.contentView=aView;
	self.contentView:setFrame(LoveUI.Rect:new(0,0, self.frame.size:get()))
end

function LoveUI.ListCell:mouseDown(theEvent)
	if theEvent.button==love.mouse_left and self.enabled then
		self.listView:setSelectedIndex(self.index);
	else
		if self.nextResponder then
			self.nextResponder:mouseDown(theEvent)
		end
	end
end
