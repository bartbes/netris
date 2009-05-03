--[[
Copyright (c) 2009 Bart Bes
 
Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:
 
The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
]]
 
local class_mt = {}
 
function class_mt:__index(key)
	if rawget(self, "__baseclass") then
		return self.__baseclass[key]
	end
	return nil
end
 
class = setmetatable({ __baseclass = {} }, class_mt)
 
function class:new(...)
	local c = {}
	c.__baseclass = self
	setmetatable(c, getmetatable(self))
	if c.init then
		c:init(...)
	end
	return c
end
 
function class:convert(t)
	t.__baseclass = self
	setmetatable(t, getmetatable(self))
	return t
end
 
function class:addparent(...)
	if not rawget(self.__baseclass, "__isparenttable") then
		local t = {__isparenttable = true, self.__baseclass, ...}
		local mt = {}
		function mt:__index(key)
			for i, v in pairs(self) do
				if i ~= "__isparenttable" and v[key] then
					return v[key]
				end
			end
			return nil
		end
		self.__baseclass = setmetatable(t, mt)
	else
		for i, v in ipairs{...} do
			table.insert(self.__baseclass, v)
		end
	end
	return self
end

function class:setmetamethod(name, value)
	local mt = getmetatable(self)
	local newmt = {}
	for i, v in pairs(mt) do
		newmt[i] = v
	end
	newmt[name] = value
	setmetatable(self, newmt)
end