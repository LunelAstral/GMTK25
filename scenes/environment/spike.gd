extends Object_Interactable

func overlap(_player : Player) -> void:
	if not _player.sprung:
		_player.position = _player.start_pos
		_player.move_target = _player.position
