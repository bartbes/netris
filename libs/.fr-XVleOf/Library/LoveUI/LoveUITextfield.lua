LoveUI.require("LoveUIControl.lua")
LoveUI.require("LoveUITextfieldCell.lua")
LoveUI.Textfield=LoveUI.Control:new();

function LoveUI.Textfield:init(frame)
	-- e.g local o=LoveUI.Object:alloc():init();
	LoveUI.Control.init(self, frame);
	self.value=nil;
	self.editable=true;
	self.selectable=true;
	self.textColor=LoveUI.defaultSecondaryColor;
	self.enabled=true;
	self.cellClass=LoveUI.TextfieldCell;
	self.cell=LoveUI.TextfieldCell:new(self, LoveUI:getImage("light-gloss-bottom-top.png"));
	self.cell.value=""
	self.shouldResignFirstResponder=false
	self.opaque=true;
	self.isFirstResponder=false;
	return self;
end

function LoveUI.Textfield:display()
	self.cell:display(self.frame, self)
end

function LoveUI.Textfield:update(dt)
	self.cell:update(dt);
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
	self.cell.state=LoveUI.OnState;
	
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
	self.cell:keyDown(theEvent);
end