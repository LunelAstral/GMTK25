extends Object_Interactable

@export var direction : String = "Right"
@export var distance : int = 3


func overlap(object : Node2D):
	object.spring(self.direction, self.distance)
