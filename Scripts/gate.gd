extends Node2D
class_name Gate

@export var shrink_area : Node2D

var is_locked := true

func _process(delta: float) -> void:
	shrink_area.scale.y =move_toward(shrink_area.scale.y, 1.0 if is_locked else 0.0, delta * 3.0)

func unlock():
	is_locked = false
	
func lock():
	is_locked = true
