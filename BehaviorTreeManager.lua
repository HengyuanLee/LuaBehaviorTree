BehTree={}
require 'BehaviorTree/Base/Enum'
require 'BehaviorTree/Base/StackList'
require 'BehaviorTree/Base/TaskRoot'
require 'BehaviorTree/Base/ITask'
require 'BehaviorTree/Base/IParent'
require 'BehaviorTree/Base/IAction'
require 'BehaviorTree/Base/IComposite'
require 'BehaviorTree/Base/IConditional'
require 'BehaviorTree/Base/IDecorator'
--复合节点（）
require 'BehaviorTree/Composite/Selector'
require 'BehaviorTree/Composite/Sequence'
--修饰节点
require 'BehaviorTree/Decorator/Repeater'
require 'BehaviorTree/Decorator/ReturnFailure'
require 'BehaviorTree/Decorator/ReturnSuccess'
require 'BehaviorTree/Decorator/UntilFailure'
require 'BehaviorTree/Decorator/Inverter'
--Action节点
require 'BehaviorTree/Action/Wait'


BehTree.BehaviorTreeManager={}
local this = BehTree.BehaviorTreeManager
function this.Init()
end
--从这里开始启动一颗行为树的入口跟节点
function this.RunTree(enter)
	this.bhTree =enter
	coroutine.start(this.OnUpdate)
end

--重置树下所有Action
function this.ResetTreeActions()
	local treeRoot = this.GetCurTreeRoot()
	treeRoot:ResetAllActionsState()
end

function this.OnUpdate() 
	while true do
		coroutine.step()
		this.UpdateTask()
	end
end
function this.UpdateTask()
	local status = this.bhTree:OnUpdate()
	if status ~= BehTree.TaskStatus.Running then
		table.remove(this.curTrees, key)
	end
	
end
