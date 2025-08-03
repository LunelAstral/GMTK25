extends Object_Interactable

@export var exit:Node2D


func overlap(object : Node2D) -> void:
	print("Teleport " + str(object) + "to:" + str(exit))
	
	# TODO: Need a teleporter pad for the player, connected via an export
# TODO linking teleporters and exporters
