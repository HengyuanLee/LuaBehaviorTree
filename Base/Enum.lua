BehTree.TaskStatus={
    Inactive = 1,
    Failure = 2,
    Success = 3,
    Running = 4
}
BehTree.TaskType={
	UnKnow = 0,
	Composite = 1,--必须包含子节点
	Decorator = 2,--必须包含子节点
	Action = 3,--最终子节点
	Conditional = 4--最终子节点
}