--[[条件节点基类]]
BehTree.IConditional = BehTree.ITask:New({})
local this = BehTree.IConditional
this.taskType = BehTree.TaskType.Conditional
