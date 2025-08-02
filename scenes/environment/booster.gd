extends Object_Interactable

@export var dir:String = ""

# TODO: Need a boost pad that will send players in one direction, either until a wall hit or after a certain amount of tiles.

func overlap(object : Node2D) -> void:
	print("Boosted " + str(object) + "in direction: " + dir )
	
		
	
