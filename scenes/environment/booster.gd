extends Object_Interactable

@export var direction:String = "Right"
@export var distance:int = -1

func overlap(object : Node2D) -> void:
	print("Boosted " + str(object) + "in direction: " + direction )
	
	if object is Player:
		object.boost(self.direction, self.distance)
