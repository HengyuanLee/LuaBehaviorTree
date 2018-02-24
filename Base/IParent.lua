--[[
父任务 Parent Tasks
behavior tree 行为树中的父任务 task 
包括：composite（复合），decorator（修饰符）！
虽然 Monobehaviour 没有类似的 API，但是并不难去理解这些功能：
]]

BehTree.IParent = BehTree.ITask:New({})
local this = BehTree.IParent
--此时this把ITask设为元表的表
--提供共有函数
function this:New(o)
	o = o or {}
	o.curChilIndex = 0
	o.curRunTask = nil
	o.childTasks={}
	--o把BehTree.IParentTask设为元表，
	--而BehTree.IParentTask把ITask设为元表
	--从而保持类的属性独立，不共用
	setmetatable(o, self)
	self.__index = self
	return o
end
--重置当前访问的子节点位置为第一个
function this:ResetChildren()
	self.curRunTask = nil
	self.curChilIndex = 0
end

function this:GetCurChildIndex()
	return self.curChilIndex
end

--对于ReaterTask等只能有一个子节点的
function this:GetOnlyOneChild()
	if self:GetChildCount() ~= 1 then
		logError('---------'..self.name..'应该有且只有一个子节点！but：childCount:'..self:GetChildCount())
		return nil
	end
	return self.childTasks[1]
end
--添加子节点有顺序要求
function this:AddChild(task)
	log('------------------'..self.name..'  添加子节点 : '..task.name)
	if task == nil then
		logError('---------------------add task is nil !!')
		return
	end
	local index = #self.childTasks+1
	task.index = index
	task.layer = self.layer + 1
	task.parent = self
	task.root = self.root
	self.childTasks[index] = task
	self.root:AddGlobalTask(task.tag, task)
	return self
end
function this:ClearChildTasks()
	self.curIndex = 0
	self.childTasks = nil
	self.childTasks = {}
end
function this:HasChildren()
	if #self.childTasks <= 0 then
		return false
	else
		return true
	end
end
function this:GetChildCount()
	return #self.childTasks
end
function this:GetNextChild()
	if #self.childTasks >= (self.curChilIndex+1) then
		--指向當前正執行的
		self.curChilIndex = self.curChilIndex + 1
		local nextChild = self.childTasks[self.curChilIndex]
		return nextChild
	else
		return nil 
	end
end
--获取前一个子节点，不移动指针
function this:GetCurPrivousTask()
	if self.curChilIndex <=1 then
		logError(self.name..' GetCurPrivousTask : 已经是最前的Task或childtask为空')
		return nil
	else
		return self.childTasks[self.curChilIndex-1]
	end
end
--获取下一个子节点，不移动指针
function this:GetCurNextTask()
	if self.curChilIndex >= #self.childTasks then
		--logError(self.name..' GetCurNextTask : 已经是最后的Task或childtask为空')
		return nil
	else
		return self.childTasks[self.curChilIndex+1]
	end
end
