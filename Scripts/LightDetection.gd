extends Area2D

@export var light_prefab : PackedScene
var lights_in_range : Array[Node2D]

func _process(delta: float) -> void:
	if lights_in_range.size() <= 0:
		var instance := light_prefab.instantiate() as Node2D
		instance.global_position = global_position
		lights_in_range.append(instance)
		get_tree().root.add_child(instance)
		print(111)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("LightPoint") and not lights_in_range.has(area):
		if area.name != "LightPointOrigin":
			lights_in_range.append(area)

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("LightPoint") and lights_in_range.has(area):
		lights_in_range.erase(area)
		
