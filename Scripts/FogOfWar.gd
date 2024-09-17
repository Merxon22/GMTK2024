extends Node2D
class_name FogOfWar

static var Instance : FogOfWar

@export var level_index := 1

# exports for editor
@export var fog: Sprite2D
@export var fogWidth = 1000
@export var fogHeight = 1000
@export var LightTexture: Texture2D
@export var lightWidth = 300
@export var lightHeight = 300
@export var player: CharacterBody2D
@export var debounce_time = 0.01

# debounce counter helper
var time_since_last_fog_update = 0.0

var fogImage: Image
var lightImage: Image
var light_offset: Vector2
var fogTexture: ImageTexture
var light_rect: Rect2

func _enter_tree() -> void:
	if Instance == null:
		Instance = self
	else:
		queue_free()
	
	update_light_size(lightHeight)

  # create black canvas (fog)
	fogImage = Image.create(fogWidth, fogHeight, false, Image.FORMAT_RGBA8)
	fogImage.fill(Color.BLACK)
	fogTexture = ImageTexture.create_from_image(fogImage)
	fog.texture = fogTexture

  # update fog once or player will be under fog until you start move
	update_fog(player.position)

func update_light_size(size : float):
	lightImage = LightTexture.get_image()
	lightImage.resize(size, size)

	# get center
	light_offset = Vector2(size/2, size/2)
	# get Rect2 from our Image to use it with .blend_rect() later
	light_rect = Rect2(Vector2.ZERO, lightImage.get_size())

# update our fog
func update_fog(pos):
	fogImage.blend_rect(lightImage, light_rect, pos - light_offset)
	fogTexture.update(fogImage)

func light_up_area(position : Vector2, radius : float):
	var light := LightTexture.get_image()
	light.resize(radius, radius)
	var offset := radius / 2.0
	
	fogImage.blend_rect(light, Rect2(Vector2.ZERO, light.get_size()), position - Vector2(offset, offset))
	fogTexture.update(fogImage)

# main render loop. Here we don't need to call update every iteration.
# So we are using debounce here to execute code each "debounce_time"
# If debounce us ready, now we can check is character moving. And update fog if it's moving.
# Here I don't use single if block for debounce + player input because we don't need to check input
# if debounce is not ready. 
func _process(delta):
	update_fog(player.position)

func _exit_tree() -> void:
	if Instance == self:
		Instance = null

### If you want to stick to mouse
### make sure you add optimizations here
#func _input(event):
#	update_fog(get_node("player").position)
