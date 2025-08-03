extends Object_Interactable

@export var direction : Vector2
@export var distance : int = 3


func overlap(player: Player):
	player.spring(self.direction, self.distance)
	SoundManager.play_sound("spring_tile")
