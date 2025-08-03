extends Object_Interactable

@export var direction:String = "Right"
@export var distance:int = 3


func overlap(_player : Node2D):
	print("Boosted " + str(_player) + "in direction: " + direction )
	_player.spring(self.direction, self.distance)
