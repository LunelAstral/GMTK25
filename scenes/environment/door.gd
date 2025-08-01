extends Object_Interactable

@export var start_open : bool = false
@export var sprite : Sprite2D

var is_open : bool :
	get:
		return is_open
	set(value):
		if value:
			open()
			is_open = value
		else:
			close()
			is_open = value

func _ready() -> void:
	super()
	is_open = start_open

func open():
	collision_layer = 0
	sprite.hide()

func close():
	collision_layer = 1
	sprite.show()
