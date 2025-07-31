extends PlayerState

var target_pos: Vector2
var speed := 200.0

func enter(_prev, data := {}) -> void:
	var dir: Vector2 = data.get("dir", Vector2.ZERO)
	var player = get_player()
	var tilemap = get_tilemap()

	var current_tile: Vector2i = tilemap.local_to_map(player.position)
	var target_tile: Vector2i = current_tile + Vector2i(dir)
	target_pos = tilemap.map_to_local(target_tile)

func update(delta: float) -> void:
	var player = get_player()
	player.position = player.position.move_toward(target_pos, speed * delta)
	if player.position == target_pos:
		finished.emit(IDLE)
