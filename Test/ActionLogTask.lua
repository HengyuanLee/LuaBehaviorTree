ActionLogTask = BehTree.IAction:New()
local this = ActionLogTask
this.name = 'ActionLogTask'
-- 模拟Behavior Designer Log节点
function this:OnUpdate()
	log('-----------ActionLogTask Success')
	return BehTree.TaskStatus.Success
end