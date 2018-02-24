BehTree.IAction = BehTree.ITask:New({})
local this = BehTree.IAction
this.name = 'IAction'
this.taskType = BehTree.TaskType.Action

function this:New(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end
