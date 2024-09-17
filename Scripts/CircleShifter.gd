extends Sprite2D
class_name CircleShifter

@export var current_data_index := 0
@export var circle_data_array : Array[CircleData]

@export var player : Player
@export var collider : CollisionShape2D
@export var particle_sys : CPUParticles2D
@export var player_dummy : PackedScene

var instantiated_dummy : RigidBody2D

func _ready():
	update_circle_data()

func _process(delta: float) -> void:
	var previous_index := current_data_index
	if Input.is_action_just_pressed("get_big"):
		change_circle_size(1)
	elif Input.is_action_just_pressed("get_small"):
		change_circle_size(-1)
		

func change_circle_size(change : int):
	var previous_index := current_data_index
	current_data_index = clampi(current_data_index + change, 0, circle_data_array.size() - 1)
	
	if previous_index != current_data_index:
		$"../GrowSound".play()
		update_circle_data()
		particle_sys.emitting = true
		
		if previous_index > current_data_index:
			if instantiated_dummy != null:
				instantiated_dummy.queue_free()
			
			instantiated_dummy = player_dummy.instantiate() as RigidBody2D
			instantiated_dummy.global_position = global_position
			instantiated_dummy.linear_velocity = player.velocity / 2.0
			get_tree().current_scene.add_child(instantiated_dummy)

func update_circle_data():
	var data := circle_data_array[current_data_index]
	var circle_size = data.circle_sprite.get_size().x
	
	if FogOfWar.Instance:
		FogOfWar.Instance.update_light_size(circle_size * 6.0)
	
	# set sprite
	texture = data.circle_sprite
	player.current_size = circle_size
	
	# set rigidbody
	player.ground_check_distance = circle_size / (1.0 + pow(player.size_percentage(), 1) * 0.9)
	
	# set collider
	var circle_collider := collider.shape as RectangleShape2D
	circle_collider.size = Vector2(circle_size, circle_size)
	
	# apply camera
	if GameCamera.Instance:
		GameCamera.Instance.update_camera_settings(data.camera_zoom, data.camera_y_offset)
