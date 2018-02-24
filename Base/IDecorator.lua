--[[装饰节点基类]]
BehTree.IDecorator = BehTree.IParent:New()
local this = BehTree.IDecorator
this.taskType = BehTree.TaskType.Decorator