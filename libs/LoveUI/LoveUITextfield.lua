--[[
Guide to LoveUI.Textfield.

Properties:
	--Property
		--[Example Values] description
		
	hidden
		[true/false] set false to hide and disable textfield
	enabled
		[true/false] set false to disable editting
	textColor
		[love.graphics.newColor(0,0,0)] set to change text color
	opaque
		[true/false] whether to draw blackground
	image
		[nil] set to nil to disable gloss
	value
		["aString"] set this to set string contents
	backgroundColor
		[aColor] set background color
	font
		[aFont] set text font.
		
	setFrame(aFrame)
		to change origin, size of Textfield
		
	selectAll()
		select all. 
	setAction(anAction, EventType, aTarget)
		Refer to LoveUI.lua, search for 'Control Events', possible Event Types are listed there. Not all are responded to. set eventType nil to use default.
]]--

LoveUI.require("LoveUIControl.lua")
LoveUI.require("LoveUITextfieldCell.lua")
LoveUI.Textfield=LoveUI.Control:new();

function LoveUI.Textfield:init(frame)
	-- e.g local o=LoveUI.Object:alloc():init();
	LoveUI.Control.init(self, frame, LoveUI.TextfieldCell:new(self, LoveUI:getImage("light-gloss-bottom-top.png")));
	self.editable=true;
	self.textColor=LoveUI.defaultTextColor;
	self.enabled=true;
	self.cellClass=LoveUI.TextfieldCell;
	self.cell.value=""
	self.shouldResignFirstResponder=false
	self.opaque=true;
	self.isFirstResponder=false;
	self.justBecameFirstResponder=false
	
	
			
	return self;
end

function LoveUI.Textfield:display()
	self.cell:display(self.frame, self)
end

function LoveUI.Textfield:update(dt)
	self.cell:update(dt);
end

function LoveUI.Textfield:selectAll()
	self.cell.selectStart=0
	self.cell.selectLength=#self.cell.value
end

function LoveUI.Textfield:mouseDown(theEvent)
	--self.color=LoveUI.graphics.newColor(0, 0, 255);
		
	self.cell:mouseDown(theEvent);
end

function LoveUI.Textfield:acceptsFirstResponder()
	return self.enabled;
end

function LoveUI.Textfield:becomeFirstResponder()
	self.isFirstResponder=true;
	if self.enabled then
		self.cell.state=LoveUI.OnState;
		self:selectAll();
		self.justBecameFirstResponder = true;
	end
	return self.enabled;
end

function LoveUI.Textfield:resignFirstResponder()
	
	return self.cell:resignFirstResponder();
end

function LoveUI.Textfield:setAction(anAction, forControlEvent)
	self.cell:setActionForEvent(anAction, forControlEvent);
end

function LoveUI.Textfield:getAction()
	return self.cell.action;
end

function LoveUI.Textfield:mouseUp(theEvent)
	self.cell:mouseUp(theEvent);
end

function LoveUI.Textfield:keyDown(theEvent)
	if theEvent.keyCode==love.key_tab then
		local selfIndex=1;
		for k, v in pairs(self.superview.subviews) do
			if v==self then
				selfIndex=k
				break;
			end
		end
		for i=selfIndex+1, #self.superview.subviews+1, 1 do
			if i>#self.superview.subviews then
				i=1;
			end
			local v=self.superview.subviews[i];
			if (v.__baseclass==LoveUI.Textfield and v.enabled and not v.hidden) or v==self then
				self.shouldResignFirstResponder=true
				self.context:setFirstResponder(v);
				break;
			end
		end
	else
		self.cell:keyDown(theEvent);
	end
	
end