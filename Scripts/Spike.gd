extends Area2D
class_name Spike

func _on_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):
		var player := body as Player
		player.respawn()
