extends CharacterBody2D
class_name Player

static var Instance : Player

var current_size := 32

@export var collider : CollisionShape2D

@export_category("Jump")
@export var jump_velocity := -400.0
@export var ground_check_distance := 15.0
var is_grounded := false

@export_category("Movement")
@export var acceleration := 10.0
@export var max_x_velocity := 50.0

@export_category("End Game")
@export var end_paiting_sprite : Sprite2D
@export var end_game_camera : Camera2D
@export_multiline var end_game_comment : String

static var game_ended := false

@export_category("Other")
@export var die_particle : PackedScene

var spawn_position := Vector2.ZERO
var last_spawn_time := -100.0

func _enter_tree() -> void:
	if Instance == null:
		Instance = self
		spawn_position = global_position
		if end_paiting_sprite:
			end_paiting_sprite.modulate.a = 0.0
	else:
		# this is a clone, remove all scripts and make collider shape independent
		collider.shape = collider.shape.duplicate()
		set_script(null)
		for child in get_children():
			child.set_script(null)
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("respawn"):
		respawn()

func _physics_process(delta):
	if Time.get_ticks_msec() < last_spawn_time + 500 or game_ended:
		return
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	var target_velocity := 0.0
	if direction:
		target_velocity = direction * max_x_velocity
	velocity.x = lerp(velocity.x, target_velocity, delta * acceleration)
	
	if Input.is_action_just_pressed("finish_game"):
		finish_game()
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity * pow(current_size / 2.0, 0.4)
		$JumpSound.play()
		if direction and direction < 0:
			$AnimationPlayer.play("jump_left")
		elif direction and direction > 0:
			$AnimationPlayer.play("jump_right")

	elif Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y /= 2
		
	is_grounded = is_on_floor()
	
	move_and_slide()
	
	var push_force = 1000.0
	# after calling move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_force(-c.get_normal() * push_force)

func _exit_tree() -> void:
	Instance = null

func size_percentage() -> float:
	return current_size / 512.0

func respawn() ->void:
	# spawn particle
	var particle := die_particle.instantiate() as CPUParticles2D
	particle.global_position = global_position
	get_tree().root.add_child(particle)
	particle.emitting = true
	var delete_tween := get_tree().create_tween()
	delete_tween.tween_callback(func(): particle.queue_free()).set_delay(3)
	
	global_position = spawn_position
	$DieSound.play()
	last_spawn_time = Time.get_ticks_msec()
	velocity = Vector2.ZERO
	
func finish_game():
	$LevelFinishSound.play()
	game_ended = true
	var reveal_time := 2.0
	var end_tween = get_tree().create_tween()
	end_paiting_sprite.visible = true
	end_tween.tween_interval(1.0)
	end_tween.tween_property(GameCamera.Instance, "global_position", end_game_camera.global_position, reveal_time).set_ease(Tween.EASE_OUT)
	end_tween.tween_property(GameCamera.Instance, "zoom", end_game_camera.zoom, reveal_time).set_ease(Tween.EASE_OUT)
	end_tween.tween_interval(1.0)
	# end_tween.tween_property(FogOfWar.Instance.fog, "modulate", Color.TRANSPARENT, reveal_time)
	end_tween.tween_property(end_paiting_sprite, "modulate", Color.WHITE, reveal_time)
	end_tween.tween_callback(func(): UIManager.Instance.show_hint_text(end_game_comment))
	
	if FogOfWar.Instance:
		PersistentManager.unlocked_levels = max(PersistentManager.unlocked_levels, FogOfWar.Instance.level_index + 1)
		
