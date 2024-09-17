extends Line2D
class_name TrailRenderer

const MAX_POINTS := 15
var curve := Curve2D.new()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	curve.add_point((get_parent() as Node2D).global_position)
	if curve.point_count > MAX_POINTS:
		curve.remove_point(0)
	points = curve.get_baked_points()
	
	
