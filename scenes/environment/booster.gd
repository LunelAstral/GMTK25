extends Object_Interactable

@export var direction : Vector2
@export var distance : int = -1

func overlap(_player: Player):
	_player.boost(self.direction, self.distance)
