extends Object
class_name Toolkit

static func get_children_by_type(node : Node, child_type):
	for child in node.get_children():
		if is_instance_of(child, child_type):
			return child
	return null
