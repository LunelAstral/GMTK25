extends Object_Interactable

@export var direction:String = "Right"
@export var distance:int = -1

func overlap(object: Node2D):
	print("Boosted " + str(object) + "in direction: " + direction)
	object.boost(self.direction, self.distance)
