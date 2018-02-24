--[[
Repeater（重复/循环）装饰节点
有且只有一个子节点！！
1 重复多少次
2 End On Failure
3 Repeat Forever
]]
BehTree.Repeater = BehTree.IComposite:New()
local this = BehTree.Repeater

--初始默认未激活
--这里的属性为了保持每个实例一份，应只能被当做元表来访问
this.curReturnStatus = BehTree.TaskStatus.Inactive
this.name = 'RepeaterTask'
--  -1 < 0 默认repeat forever
this.repeatCount = -1
this.isOnPause = false
--<0无限次repeat，==0结束，>0倒数repeat
function this:SetRepeatCount(count)
	self.repeatCount = count
end
--暂停repeat,参数bool
function this:PauseRepeat(b)
	self.isOnPause = b
end
function this:GetChildStatus()
	return self.curReturnStatus
end
function this:OnUpdate()
	--暂停状态，不去Update子节点
	if self.isOnPause == true then
		return BehTree.TaskStatus.Running
	end
	self.curRunTask = self:GetOnlyOneChild()
	--如果是复合节点，重置回初始状态
	if self.curRunTask.taskType == BehTree.TaskType.Composite then
		--self.curRunTask:ResetChildren()
	end
	if self.curRunTask == nil then
		logError('-错误的行为树结构--------------'..self.name..' 获取子节点失败')
		return BehTree.TaskStatus.Failure
	end
	--<!=0无限次repeat，==0结束，>0倒数repeat
	--真正Repeat重复子节点
	if self.repeatCount ~= 0 then
		--记录子节点的状态
		self.curReturnStatus = self.curRunTask:OnUpdate()
	end
	--默认一直循环
	if self.repeatCount == 0 then
		return BehTree.TaskStatus.Failure
	elseif self.repeatCount >= 1 then
		self.repeatCount = self.repeatCount - 1
		return BehTree.TaskStatus.Running
	else
		return BehTree.TaskStatus.Running
	end
end