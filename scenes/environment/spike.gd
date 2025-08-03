extends Object_Interactable

func overlap(object : Node2D) -> void:
	print("killed " + str(object))
	if object.is_grounded:
		object.begin_loop()
