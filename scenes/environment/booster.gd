extends Object_Interactable

@export var direction:String = "Right"
@export var distance:int = -1

# TODO: Need a boost pad that will send players in one direction, either until a wall hit or after a certain amount of tiles.

func overlap(object : Node2D) -> void:
	print("Boosted " + str(object) + "in direction: " + direction )
	
	# TODO When player touches the pad
	# They start sliding in said direction
	# Then they continue until distance is 0, or until they hit a wall
	# Should feed player 2 vars, direction and distance
	
		
	
