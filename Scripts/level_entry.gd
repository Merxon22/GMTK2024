extends Area2D
class_name LevelEntry

@export var locked_sprite : Texture2D
@export var unlocked_sprite : Texture2D
@export var canvas_sprite : Sprite2D

@export var level_index : int
@export var level_name_label : Label
@export_multiline var painting_name : String
@export_multiline var hint_content : String
@export var scene : PackedScene

var selected_by_player := false

func _enter_tree() -> void:
	# is unlocked
	if PersistentManager.unlocked_levels > level_index:
		canvas_sprite.texture = unlocked_sprite
		level_name_label.text = "Level " + str(level_index) + "\n<" + painting_name + ">"
	# is locked
	else:
		canvas_sprite.texture = locked_sprite
		level_name_label.text = "Level " + str(level_index) + "\n<???>"	
	
	level_name_label.visible = false
	$CanvasDisplayHorizontal.material = $CanvasDisplayHorizontal.material.duplicate()
	toggle_outline(false)

func _process(delta: float) -> void:
	if selected_by_player and Input.is_action_just_pressed("select_level"):
		if scene != null and PersistentManager.unlocked_levels >= level_index:
			get_tree().change_scene_to_packed(scene)

func _on_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):
		selected_by_player = true
		level_name_label.visible = true
		toggle_outline(true)
		if PersistentManager.unlocked_levels >= level_index or scene == null:
			UIManager.Instance.show_hint_text(hint_content)
		else:
			UIManager.Instance.show_hint_text("...Locked...")

func _on_body_exited(body: Node2D) -> void:
	if is_instance_of(body, Player):
		selected_by_player = false
		level_name_label.visible = false
		toggle_outline(false)
		UIManager.Instance.hide_hint_text()
		
func toggle_outline(is_visible : bool):
	$CanvasDisplayHorizontal.material.set_shader_parameter("outline_width", 1.0 if is_visible else 0.0)
