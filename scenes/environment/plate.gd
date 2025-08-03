class_name Plate extends Object_Interactable

@export var sprite : Sprite2D
@export var target_door: Object_Interactable

func overlap(_player: Player):
	target_door.is_open = true
	sprite.frame = 1
	SoundManager.play_sound("pressure_plate_activating")
	# TODO tweak this so it isnt an explicit call to the node

func reset() -> void:
	target_door.is_open = false
	sprite.frame = 0

func exit(_player: Player):
	if not get_overlapping_bodies():
		target_door.is_open = false
		sprite.frame = 0
		SoundManager.play_sound("pressure_plate_deactivating")
