--下面来了解一下行为树：
--有四种不同类型的 task(任务): 包括
--1 action（行为），
--2 composite（复合），--1,EntryParallel | 2,Selector | 3,Sequence
--3 conditional（条件），
--4 decorator（修饰符）！--Interrupt  Repeater  UntilSuccess
--5 action（行为）
--可能很容易理解，因为他们在某种程度上改变游戏的状态和结果。 

BehTree.TaskRoot = {
	taskStackList = BehTree.StackList:New(),
	name = '根起始点',
	layer = 0,
	desc = '行为树入口',
	curRunTask = nil,
	taskList = {},--此行为树下所有节点
	globalTable={}--此行为树的全局共享参数
}
local this = BehTree.TaskRoot


function this:New()	
	local o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end
----------------通过tag保存Task
function this:AddGlobalTask(tag, task)
	local key = tostring(tag)
	self.taskList[key] = task
end
function this:FindGlobalTask(tag)
	local task = self.taskList[tostring(tag)]
	if task == nil then
		logError(self.name..' TaskRoot can not find task by tag: '..tag)
	end
	return task
end
function this:GetAllTasks()
	return self.taskList
end
----------------end
----------------此树下全局参数
function this:SetGlobalParam(key, data)
	self.globalTable[key] = data
end
function this:GetGlobalParam(key)
	local data = self.globalTable[key]
	if data == nil then
		logError('找不到全局参数：'..tostring(key))
	end
	return data
end
------------------end
function this:SetStart(task)
	self.startTask = task
end

function this:ResetAllActionsState()
	for tag,task in pairs(self.taskList) do
		if task.taskType == BehTree.TaskType.Action then
			if type(task.isOnAction) == 'number' then
				if task.isOnAction == 1 then
					task.isOnAction = 2
					log(task.name..' reset isOnAction == 2 ')
				end
				
			end
		end
	end
end

function this:PushTask(task)
	task.parent = self
	task.root = self
	task.layer = self.layer + 1
	self.startTask = task
end
function this:IsParentTypeTask(task)
	if task.taskType == BehTree.TaskType.Composite or task.taskType == BehTree.TaskType.Decorator then
		return true
	else
		return false
	end
end
function this:OnTopTaskChange()
	local topTask = self.taskStackList:GetTop()
	if self:IsParentTypeTask(topTask) == true then

	else
	--action 节点
		self.curRunTask = topTask
	end
end
function this:PopTask()
	return self.taskStackList:Pop()
end

--如果是
function this:OnUpdate()
	if self.startTask ~= nil then
		return self.startTask:OnUpdate()
	else
		return BehTree.TaskStatus.Failure
	end

end