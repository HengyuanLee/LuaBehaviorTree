--[[
所有task基础
]]
BehTree.ITask={
	--不需要主动设置参数
	--由树结构的机制驱动的参数，
	taskStatus = BehTree.TaskStatus.Running,
	curReturnStatus = BehTree.TaskStatus.Inactive,
	taskType = BehTree.TaskType.UnKnow,
	root = nil,
	index = 1,
	parent = nil,
	layer = 1,

	--主动设置参数
	name = '暂未设置名称',
	tag = 'UnTag',--用于搜索
	desc = '暂无描述'
}
local this = BehTree.ITask
function this:New(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function this:ResetTaskStatus()
end
--获取同一层layer的上一个节点
function this:GetPriviousTask()
	if self.parent == nil then
		logError(self.name..' 找不到父节点 try call GetPriviousTask')
		return nil
	end
	if self.layer <= 1 then
		logError(self.name..' GetPriviousTask已经是最顶层，单独Task')
		return nil
	end
	local priviousTask = self.parent:GetCurPrivousTask()
	return priviousTask
end
--获取同一层layer下一个task
function this:GetNextTask()
	if self.parent == nil then
		logError(self.name..' 找不到父节点 try call GetNextTask')
		return nil
	end
	if self.layer <= 1 then
		logError(self.name..' GetNextTask已经是最顶层，单独Task')
		return nil
	end
	local nextTask = self.parent:GetCurNextTask()
	return nextTask
end

function this:ToString()
	local name = '名称 : '..self.name..'\n'
	local layer = '所处层次 ：'..self.layer..'\n'
	local parent = '父节点 : '..self.parent.name..'\n'
	local index = '作为子节点顺序 : '..self.index..'\n'
	local desc = '描述 : '..self.desc..'\n'
	local status = 'UnKnow'
	if self.curReturnStatus == 1 then
		status = 'Inactive'
	elseif self.curReturnStatus == 2 then
		status = 'Failure'
	elseif self.curReturnStatus == 3 then
		status = 'Success'
	elseif self.curReturnStatus == 4 then
		status = 'Running'
	end
	local curReturnStatus = '运行返回结果：'..status..'\n'
	return name..desc..layer..parent..index..curReturnStatus
end
