extends Object_Interactable

func overlap(object : Node2D) -> void:
	print("killed " + str(object))
	
	# TODO: KILL THE PLAYER 
	# when they touch this object
	# should be as easy as calling the time reset func
