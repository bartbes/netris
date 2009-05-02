LoveUI.require("LoveUIControl.lua")
LoveUI.require("LoveUIButtonCell.lua")
LoveUI.Button=LoveUI.Control:new()

function LoveUI.Button:init(frame)
	-- e.g local o=LoveUI.Object:alloc():init();
	LoveUI.Control.init(self, frame);
	self.value=nil;
	self.enabled=true;
	self.state=LoveUI.OffState;
	self.title="Button";
	self.alternateTitle=nil;
	self.cellClass=LoveUI.ButtonCell;
	self.cell=LoveUI.ButtonCell:new(self, LoveUI:getImage("light-gloss-bottom-top.png"));
	self.cell.alternateImage=LoveUI:getImage("heavy-gloss-top-bottom.png")
	self.opaque=true;
	self.backgroundColor=LoveUI.defaultForegroundColor;
	return self;
end
--[[
function LoveUI.Button:copy()
	local cpy=LoveUI.Object.copy(self, "cell");
	return cpy
end
]]--
function LoveUI.Button:display()
	self.cell:display(self.frame, self);

end

function LoveUI.Button:update(dt)
	self.cell:update(dt)
end

function LoveUI.Button:mouseDown(theEvent)
	--self.color=love.graphics.newColor(0, 0, 255);
		
	self.cell:mouseDown(theEvent);
end

function LoveUI.Button:acceptsFirstResponder()
	return self.enabled;
end

function LoveUI.Button:setAction(action, controlEvent, aTarget)
	self.cell:setActionForEvent(action, controlEvent, aTarget)
end

function LoveUI.Button:mouseUp(theEvent)
	self.cell:mouseUp(theEvent);
	
end