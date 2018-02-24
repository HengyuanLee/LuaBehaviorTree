--[[
or 类型
]]
BehTree.Selector = BehTree.IComposite:New()
local this = BehTree.Selector
--初始默认未激活
this.curReturnStatus = BehTree.TaskStatus.Inactive
this.name = 'SelectorTask'
function this:OnUpdate()
	if self:HasChildren() == false then
		logError(self.name..'父节点类型没有子节点！！')
		return BehTree.TaskStatus.Failure
	end
	if self.curRunTask == nil then
		--选择（or）节点肯定是去找子节点
		self.curRunTask = self:GetNextChild()
				--如下不该发生
		if self.curRunTask == nil then
			--如果没有子节点
			logError('错误的节点配置！：没有子节点或已越界！！'..self.name..'子节点长度：'..self:GetChildCount()..'   尝试访问：'..self:GetCurChildIndex()+1)
			return BehTree.TaskStatus.Failure
		end
	end
	return self:RunChildByOr()
end
--or 机制
----选择组合节点：OR逻辑，直到有一个Success就返回Success
function this:RunChildByOr()
	--接下来self.curRunTask~=nil
	while self.curRunTask ~= nil do
		self.curReturnStatus = self.curRunTask:OnUpdate() --self.root:PushTask(self.curRunTask)
		self.curRunTask:ResetTaskStatus()
		--log('cur running task : '..'\n'..self.curRunTask:ToString())
		----or机制：只要有一个true就中断执行,这一帧到此结束
		if self.curReturnStatus == BehTree.TaskStatus.Success then
			--返回Success说明这次Selector走完了，重置等下一轮
			self:Reset()
			return BehTree.TaskStatus.Success
		elseif self.curReturnStatus == BehTree.TaskStatus.Running then
			return self.curReturnStatus
		else
			--false的时候队列执行下一个
			self.curRunTask = self:GetNextChild()
		end
	end
	--执行完了还没找到一个true
	--走到尽头返回，说明这次Selector走完了，重置等下一轮
	self:Reset()
	self.curReturnStatus = BehTree.TaskStatus.Failure
	return BehTree.TaskStatus.Failure
end

--重置
function this:Reset()
	--self.curReturnStatus = BehTree.TaskStatus.Inactive
	self:ResetChildren()
end