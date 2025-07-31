extends PlayerState

var target_pos: Vector2
var speed := 200.0

func enter(_prev, data := {}) -> void:
	var dir: Vector2 = data.get("dir", Vector2.ZERO)
	target_pos = get_move_target(dir, speed)

func update(delta: float) -> void:
	var player = get_player()
	player.position = player.position.move_toward(target_pos, speed * delta)
	if player.position == target_pos:
		finished.emit(IDLE)
