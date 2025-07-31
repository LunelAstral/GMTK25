extends PlayerState

func handle_input(event: InputEvent) -> void:
	var dir := Vector2.ZERO

	if event.is_action_pressed("ui_up"):
		dir = Vector2.UP
	elif event.is_action_pressed("ui_down"):
		dir = Vector2.DOWN
	elif event.is_action_pressed("ui_left"):
		dir = Vector2.LEFT
	elif event.is_action_pressed("ui_right"):
		dir = Vector2.RIGHT

	if dir != Vector2.ZERO:
		var tilemap := get_tilemap()
		var player := get_player()

		var current_tile := tilemap.local_to_map(player.position)
		var target_tile := current_tile + Vector2i(dir)
		var target_world_pos := tilemap.map_to_local(target_tile)


		# Setup proper physics query parameters
		var params := PhysicsPointQueryParameters2D.new()
		params.position = target_world_pos
		params.collision_mask = 1  # make sure your walls/obstacles use this
		params.collide_with_areas = true
		params.collide_with_bodies = false

		var space_state := player.get_world_2d().direct_space_state
		var results := space_state.intersect_point(params)

		if results.size() > 0:
			return  # Blocked

		finished.emit(MOVE, { "dir": dir })
		
