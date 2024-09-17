extends Area2D
class_name NodeActivationTrigger

func _ready() -> void:
	for node in get_children():
		if node != null:
			node.visible = false

func _on_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):
		for node in get_children():
			node.visible = true
