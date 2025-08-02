extends Object_Interactable

var dir:String = ""

func overlap(object : Node2D) -> void:
	print("Send " + str(object))
	

# TODO: Need a boost pad that will send players in one direction, either until a wall hit or after a certain amount of tiles.
