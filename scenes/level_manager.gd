extends TileMapLayer
class_name Game_TileMap

var door_registry: Dictionary = {} # Maps int IDs to arrays of doors

func register_door(id: int, door: Node) -> void:
	if not door_registry.has(id):
		door_registry[id] = []
	door_registry[id].append(door)

func trigger_door(id: int, should_open: bool) -> void:
	if door_registry.has(id):
		for door in door_registry[id]:
			if should_open: door.open()
			else: door.close()
	else:
		print("No doors registered with ID:", id)
