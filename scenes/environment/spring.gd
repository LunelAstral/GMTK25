extends Object_Interactable

@export var dir : String = "Right"
@export var dist : int = 3


func overlap(object : Node2D):
	object.spring(self.direction, self.distance)
