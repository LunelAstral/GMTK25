extends Object_Interactable

@export var sprite : Sprite2D

@export var connected_doors: Array[Object_Interactable]
@export var can_toggle := false

func _ready():
	super()
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	
	sprite.frame = 0

func _on_body_entered(body):
	if body.is_in_group("player"):
		sprite.frame = 1
		
		for door in connected_doors:
			if "is_open" in door:
				door.is_open = !door.is_open

func _on_body_exited(body):
	if body.is_in_group("player"):
		sprite.frame = 0
		
		for door in connected_doors:
			if "is_open" in door:
				if not can_toggle:
					door.is_open = !door.is_open
