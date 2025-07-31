extends CharacterBody2D

@onready var tilemap: TileMapLayer = get_parent()

func get_tilemap() -> TileMapLayer:
	return tilemap
