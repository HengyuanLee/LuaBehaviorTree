--[[
常用于Sequence的第一个节点判断
]]
BehTree.IComposite = BehTree.IParent:New()
local this = BehTree.IComposite
this.taskType = BehTree.TaskType.Composite

