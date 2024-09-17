extends CanvasLayer
class_name UIManager

static var Instance : UIManager

@export var hint_label : Label
@export var point_label: Label
@export var point_sprite : Texture2D
@export var point_image : TextureRect

@export var menu_button : Button

var type_tween : Tween

func _enter_tree() -> void:
	if Instance == null:
		Instance = self
		self.visible = true
	else:
		queue_free()
		
	hint_label.text = ""
	point_image.texture = point_sprite
	
func _ready() -> void:
	point_image.visible = FogOfWar.Instance != null
	set_menu_button_visible(FogOfWar.Instance != null)

func _process(delta: float) -> void:
	point_label.text = str(PickupPoint.current_point) + "/" + str(PickupPoint.total_point)

func show_gain_score_anim():
	$PointCount/AnimationPlayer.play("score_pop")

func show_hint_text(text : String) -> void:
	hint_label.text = text
	hint_label.visible_ratio = 0
	if type_tween != null:
		type_tween.stop()
	type_tween = get_tree().create_tween()
	type_tween.tween_property(hint_label, "visible_ratio", 1.0, 0.5)
	$Hint/AudioStreamPlayer2D.play()

func set_menu_button_visible(is_visible : bool) -> void:
	menu_button.visible = is_visible

func hide_hint_text() -> void:
	if type_tween != null:
		type_tween.stop()
	if get_tree():
		type_tween = get_tree().create_tween()
		type_tween.tween_property(hint_label, "visible_ratio", 0.0, 0.5)


func _back_to_menu() -> void:
	get_tree().change_scene_to_file("res://Scenes/StartScene.tscn")
	Player.game_ended = false
	PickupPoint.current_point = 0
	PickupPoint.total_point = 0
