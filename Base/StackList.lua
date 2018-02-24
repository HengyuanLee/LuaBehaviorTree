--[[注意：只支持默认数字连续键值！！！]]
BehTree.StackList = {}
local this = BehTree.StackList
this.count = 0
function this:New()
	self.stack_list = {}
	setmetatable(self, this)
	this.__index = this
	return self
end

function this:Push(element)
	self.count = self.count+1
	self.stack_list[self.count] = element
end

function this:Pop()
	if self.count < 1 then
		logError('stack_list self.count is 0!!')
		return
	end
	local pope = table.remove(self.stack_list, self.count)
	self.count = self.count-1
	return pope
end

function this:Count()
	return self.count
end

function this:GetTop()
	local top = self.stack_list[self.count]
	return top
end

function this:Contain(e)
	for i=1, self.count do
		if e == self.stack_list[i] then
			return true
		end
	end
	return false
end

function this:Clear()
	self.stack_list = nil
	self.stack_list = {}
	self.count = 0
end

function this:ToString()
	if self.count <= 0 then
		logWarn('this self.Count is : 0')
	end
	for k, v in pairs(self.stack_list) do
		log('Stack 信息： key ：'..k..'   vale: '..tostring(v))
	end
end