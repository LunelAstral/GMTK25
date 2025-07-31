extends Object_Interactable

@export var door_id: int

func _ready() -> void:
	super()
	tilemap.register_door(door_id, self)

func open():
	collision_layer = 0

func close():
	collision_layer = 1
