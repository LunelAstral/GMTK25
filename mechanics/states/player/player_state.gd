class_name PlayerState extends State

const MOVE := &"MoveState"
const IDLE := &"IdleState"

enum moves {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var moves_recording = []

func get_move_target(dir, speed):
	var player = get_player()
	var tilemap = get_tilemap()

	var current_tile: Vector2i = tilemap.local_to_map(player.position)
	var target_tile: Vector2i = current_tile + Vector2i(dir)
	return tilemap.map_to_local(target_tile)

func get_player() -> Node2D:
	return owner

func get_tilemap() -> TileMapLayer:
	return owner.get_parent() as TileMapLayer
