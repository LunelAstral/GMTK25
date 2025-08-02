extends Object_Interactable

@export var dir:String = ""
@export var dist:int = 0

# TODO: Need a spring pad that will "launch" the player to usually unreachable areas.

func overlap(object : Node2D) -> void:
	print("Boosted " + str(object) + "in direction: " + dir )
	
		
	
