extends PlayerState

func handle_input(event: InputEvent) -> void:
	var dir := Vector2.ZERO
	
	var to_move = null
	
	if event.is_action_pressed("ui_up"):
		dir = Vector2.UP
		to_move = moves.UP
	elif event.is_action_pressed("ui_down"):
		dir = Vector2.DOWN
		to_move = moves.DOWN
	elif event.is_action_pressed("ui_left"):
		dir = Vector2.LEFT
		to_move = moves.LEFT
	elif event.is_action_pressed("ui_right"):
		dir = Vector2.RIGHT
		to_move = moves.RIGHT

	if dir != Vector2.ZERO:
		var next = get_next_tile(dir)
		
		if next.size() > 0 and next[0].collider.is_in_group("solid"):
			print(typeof(next[0].collider))
			return  # Blocked
		
		moves_recording.append(to_move)
		finished.emit(MOVE, { "dir": dir })
		
		print(moves_recording)
