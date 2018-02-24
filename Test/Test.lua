require 'BehaviorTree/Test/TestConditionalTask'
require 'BehaviorTree/Test/ActionLogTask'

--[[
代码拼接行为树有代码结构顺序要求，
代码顺序也遵从行为树的图示，上到下，从左到右拼接
上层或者本节点的前一个节点完成才能进行下一个
]]
local function BuildTree()
	local root = BehTree.TaskRoot:New()

	--这里直接使用Repeater作为入口并且检测，相当于Entry
	local entry = BehTree.Repeater:New()
	entry.name = '第0个复合节点repeat == Entry '
	--根节点添加layer：1
	root:PushTask(entry)

--------layer:2
	local selector1 = BehTree.Selector:New()
	selector1.name = '第1个复合节点selector == Selector '
	entry:AddChild(selector1)
	
	-----layer3
	local sequence2 = BehTree.Sequence:New()
	sequence2.name = '第2个复合节点sequence == Sequence'
	selector1:AddChild(sequence2)

	--layer:4,并行
	local testConditionalTask = TestConditionalTask:New()
	testConditionalTask.name = '并行第3个叶子节点 == Is Null Or Empty'
	local actionLogTask = ActionLogTask:New()
	actionLogTask.name = '并行第3个叶子节点 == Log'
	--添加
	sequence2:AddChild(testConditionalTask)--child:1
	sequence2:AddChild(actionLogTask)--child:2

	return root
end

return BuildTree()


