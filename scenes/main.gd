extends Node

@export var initial_scene = PackedScene

func _ready() -> void:
	GameGlobalEvents.load_scene.connect(_on_load_scene)
	
	_on_load_scene(initial_scene)

func _on_load_scene(scene: PackedScene) -> void:
	for child in get_children():
		call_deferred("remove_child", child)
	
	var new_scene = scene.instantiate()
	call_deferred("add_child", new_scene)
