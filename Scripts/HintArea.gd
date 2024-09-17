extends Area2D
class_name HintArea

@export_multiline var hint_content : String

func _on_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):
		UIManager.Instance.show_hint_text(hint_content)


func _on_body_exited(body: Node2D) -> void:
	if is_instance_of(body, Player):
		UIManager.Instance.hide_hint_text()
