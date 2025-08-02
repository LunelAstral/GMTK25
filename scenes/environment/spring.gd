extends Object_Interactable

@export var dir:String = "Right"
@export var dist:int = -1


func overlap(object : Node2D) -> void:
	print("Boosted " + str(object) + "in direction: " + dir )
	
	# TODO: Need a spring pad that will "launch" the player to usually unreachable areas.
	# this is just Booster, but we ignore walls
	# Same idea, but call on a player func 
	# Call on a func that takes booster vars, then does the same thing but also turns off collision for that many steps
	
