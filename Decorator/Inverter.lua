--[[
--有且只有一个子节点
running 则返回running
Success和Failure：子节点的任务完成后返回值，在这个节点会被取反并传递到上一级中！
]]
BehTree.Inverter = BehTree.IDecorator:New()
local this = BehTree.Inverter
this.name = 'Inverter Decorator'

--初始默认未激活
--这里的属性为了保持每个实例一份，应只能被当做元表来访问
this.curReturnStatus = BehTree.TaskStatus.Inactive

function this:OnUpdate()
	self.curRunTask = self:GetOnlyOneChild()
	if self.curRunTask == nil then
		logError('---------错误的节点结构------'..self.name..' 获取子节点失败')
		return BehTree.TaskStatus.Failure
	end
	self.curReturnStatus = self.curRunTask:OnUpdate()
	if self.curReturnStatus == BehTree.TaskStatus.Inactive then
		logError('错误: '..self.name..' 未初始化：TaskStatus==Inactive!')
		return BehTree.TaskStatus.Failure
	end
	--遇到running返回
	if self.curReturnStatus == BehTree.TaskStatus.Running then
		return BehTree.TaskStatus.Running
	elseif self.curReturnStatus == BehTree.TaskStatus.Success then
		--其他返回Failure
		return BehTree.TaskStatus.Failure
	elseif self.curReturnStatus == BehTree.TaskStatus.Failure then
		return BehTree.TaskStatus.Success
	end
end
