extends Area2D
class_name Object_Interactable

var tilemap : TileMapLayer

# Make sure anything extending this class is a child of the tilemap
func _ready() -> void:
	tilemap = get_parent()

func overlap(player : Player) -> void:
	pass
