extends Area2D
class_name ButtonTrigger

@export var button_sprite : Sprite2D
@export var gate : Gate

var entered_bodies : Array[Node2D]

func _process(delta: float) -> void:
	if is_pressed():
		button_sprite.scale.y = 0.5
	else:
		button_sprite.scale.y = 1

func _on_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player) or is_instance_of(body, RigidBody2D):
		if not is_pressed():
			$PressedSound.play()
			gate.unlock()
		entered_bodies.append(body)

func _on_body_exited(body: Node2D) -> void:
	if is_instance_of(body, Player) or is_instance_of(body, RigidBody2D):
		entered_bodies.erase(body)
		if not is_pressed():
			$PressedSound.play()
			gate.lock()
			
func is_pressed() -> bool:
	return entered_bodies.size() > 0
