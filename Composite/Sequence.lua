BehTree.Sequence = BehTree.IComposite:New()
local this = BehTree.Sequence
--初始默认未激活
this.curReturnStatus = BehTree.TaskStatus.Inactive
this.name = 'Sequence'
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
	return self:RunChildByAnd()
end
--and:遇到一个false就中断执行
--序列组合节点：AND逻辑，所有子节点Success才返回Success
function this:RunChildByAnd()

	while self.curRunTask ~= nil do
		self.curReturnStatus = self.curRunTask:OnUpdate() 
		self.curRunTask:ResetTaskStatus()
		--找到false或者running直接返回,就中断执行,这一帧到此结束
		if self.curReturnStatus == BehTree.TaskStatus.Failure then
			--返回Failure说明这次Sequence走完了，重置等下一轮
			self:Reset()
			return BehTree.TaskStatus.Failure
		 elseif self.curReturnStatus == BehTree.TaskStatus.Running then
			return BehTree.TaskStatus.Running
		else
			--没找到false就一直执行下去
			self.curRunTask = self:GetNextChild()
		end
	end

	--找完了所有节点没有false，那么success
	--说明这次Sequence走完了，重置等下一轮
	self.curReturnStatus = BehTree.TaskStatus.Success
	self:Reset()
	return BehTree.TaskStatus.Success
end
--重置
function this:Reset()
	self:ResetChildren()
end