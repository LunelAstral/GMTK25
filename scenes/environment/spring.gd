extends Object_Interactable

@export_enum() var dir : String = "Right"
@export var dist : int = 3


func overlap(object : Node2D):
	print("Boosted " + str(object) + "in direction: " + direction )
	object.spring(self.direction, self.distance)
