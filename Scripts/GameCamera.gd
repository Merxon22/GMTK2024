extends Camera2D
class_name GameCamera

static var Instance : GameCamera

@export var zoom_lerp_speed := 5
var target_zoom : float
var target_y_offset : float

func _enter_tree() -> void:
	if Instance == null:
		Instance = self
	else:
		queue_free()
	target_zoom = zoom.x
	target_y_offset = offset.y

func _ready() -> void:
	global_position = Player.Instance.global_position

func _process(delta):
	if not Player.game_ended:
		global_position = Player.Instance.global_position
		zoom = zoom.lerp(Vector2(target_zoom, target_zoom), zoom_lerp_speed * delta)
		offset = offset.lerp(Vector2(0, target_y_offset), zoom_lerp_speed * delta)

func _exit_tree() -> void:
	if Instance == self:
		Instance = null

func update_camera_settings(camera_zoom : float, y_offset : float):
	target_zoom = camera_zoom
	target_y_offset = y_offset
