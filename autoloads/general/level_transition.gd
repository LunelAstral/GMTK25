extends Node

func _ready() -> void:
	GameGlobalEvents.load_scene.connect(_load_level)

func _load_level(scene: PackedScene) -> void:
	for child in get_children():
		remove_child(child)
	
	var new_scene = scene.instantiate()
	add_child(new_scene)
