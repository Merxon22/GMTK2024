extends Area2D
class_name PickupPoint

static var total_point := 0
static var current_point := 0

var is_picked := false

func _ready() -> void:
	total_point += 1
func _on_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):
		if not is_picked:
			is_picked = true
			current_point += 1
			$UnpickedSprite.visible = false
			$PickedSprite.visible = true
			$AudioStreamPlayer2D.play()
			UIManager.Instance.show_gain_score_anim()
			
			if current_point >= total_point:
				Player.Instance.finish_game()
				
		$PickedSprite/CPUParticles2D.emitting = true
		Player.Instance.spawn_position = global_position
