extends Object_Interactable

func overlap(_player : Player) -> void:
	print("killed " + str(_player))
	if _player.is_grounded:
		_player.begin_loop()
