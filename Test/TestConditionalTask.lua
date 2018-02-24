TestConditionalTask = BehTree.IConditional:New()
local this = TestConditionalTask
this.name = 'TestConditionalTask'
testt = {}
idnex = 1
--
function this:OnUpdate()
	log('----------TestConditionalTask---------Running')
	log(self:ToString())
	--模拟Behavior Designer IsNullOrEmpty节点
	--IsNullOrEmpty == false
	return BehTree.TaskStatus.Failure
end