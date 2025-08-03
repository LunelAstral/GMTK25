class_name Plate extends Object_Interactable

@export var target_door: Object_Interactable

func overlap(_player: Player):
	print("Plate activated")
	target_door.is_open = true
	$Sprite2D.frame = 21
	
	# TODO tweak this so it isnt an explicit call to the node
	
func exit(_player: Player):
	print("Plate left")
	if not get_overlapping_bodies():
		target_door.is_open = false
		$Sprite2D.frame = 20
