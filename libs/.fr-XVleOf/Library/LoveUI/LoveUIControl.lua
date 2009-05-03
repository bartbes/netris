LoveUI.require("LoveUIView.lua")
LoveUI.Control=LoveUI.View:new();

function LoveUI.Control:init(frame)
	-- e.g local o=LoveUI.Object:alloc():init();
	LoveUI.View.init(self, frame);
	self.cellClass=LoveUI.Cell;
	self.cell=nil;
	
	self.value="";
	self.enabled=true;
	self.ignoresMultiClick=false;
	self.font=LoveUI.DEFAULTFONT;
	
	self.action=nil;
	self.target=nil;
	return self;
end

function LoveUI.Control:stringValue()
	-- return value as string
	return tostring(self.value)
end

function LoveUI.Control:performClick(sender)
	
end

function drawCell(dt)
end

function updateCell()
end