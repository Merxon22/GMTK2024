extends Area2D
class_name GrowToken


func _on_body_entered(body: Node2D) -> void:
	var player := body as Player
	if player != null:
		$CPUParticles2D.emitting = true
		(Toolkit.get_children_by_type(player, CircleShifter) as CircleShifter).change_circle_size(1)
		#queue_free()
