extends Object_Interactable

@export var next_level : PackedScene

func overlap(_player: Player):
	if next_level:
		GameGlobalEvents.load_scene.emit(next_level)
