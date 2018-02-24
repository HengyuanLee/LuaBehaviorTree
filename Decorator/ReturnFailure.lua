--[[
--有且只有一个子节点
只要子节点当前的状态不是 running，
也就是子节点执行结果无论是 success 还是 failure，都返回 failure！
如果子节点状态是 running的话则返回 running！
]]
BehTree.ReturnFailure = BehTree.IDecorator:New()
local this = BehTree.ReturnFailure
this.name = 'ReturnFailure Decorator'
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
	else
		--其他返回Failure
		return BehTree.TaskStatus.Failure
	end
end


