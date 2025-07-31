class_name PlayerState extends State

const MOVE := &"MoveState"
const IDLE := &"IdleState"

func get_player() -> Node2D:
	return owner

func get_tilemap() -> TileMapLayer:
	return owner.get_parent() as TileMapLayer
