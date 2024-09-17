extends Marker2D

@export var size := 16.0
var is_lit := false
# Called when the node enters the scene tree for the first time.
func _process(delta) -> void:
	if not is_lit and self.is_visible_in_tree():
		is_lit = true
		FogOfWar.Instance.light_up_area(global_position, size)
