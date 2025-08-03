extends Object_Interactable

@export var direction:String = "Right"
@export var distance:int = -1

func overlap(object: Node2D):
	print("Plate activated")
	
	# TODO this should point to a tile that is solid, then turn it off while it is active
	# TODO linking pressure plates / gates

	
