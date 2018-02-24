--[[
等待指定的时间，期间此Task将一直返回Running，
一直到时间消逝完后，
返回 Success
]]
BehTree.Wait = BehTree.IAction:New()
local this = BehTree.Wait
this.name = '等待Action'
this.desc = '期间返回Running,时间消逝完后返回Success'
this.waitTime = 0
this.isOnCD = false
--上一轮的倒数是否结束，现在是否应该进行倒数
this.lastFinish = true

function this:SetWait(s)
	self.waitTime = s
end

function this:OnUpdate()
	self.curReturnStatus = BehTree.TaskStatus.Inactive
	--默认不倒数，直接返回Success
	if self.waitTime == 0 then
		self.curReturnStatus = BehTree.TaskStatus.Success
		return BehTree.TaskStatus.Success
	end
	--上一轮已经结束，而且这轮还没开始倒数
	if  self.lastFinish == true and self.isOnCD == false then
		self.isOnCD = true
		self.lastFinish = false
		self:CountBackwards()
	end
	if self.isOnCD == false then
		self.curReturnStatus = BehTree.TaskStatus.Success
		self.lastFinish = true
		return BehTree.TaskStatus.Success
	else
		self.curReturnStatus = BehTree.TaskStatus.Running
		return BehTree.TaskStatus.Running
	end
end
--倒数
function this:CountBackwards()
	coroutine.start(function()
		coroutine.wait(self.waitTime)
		self.isOnCD = false
	end)
end
