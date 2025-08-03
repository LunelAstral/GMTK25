extends Object_Interactable

@export var direction:String = "Right"
@export var distance:int = -1

func overlap(_player: Player):
	print("Boosted " + str(_player) + "in direction: " + direction)
	_player.boost(self.direction, self.distance)
