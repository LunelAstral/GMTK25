extends Object_Interactable

@export var target_id: int

func _ready():
	super()
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		tilemap.trigger_door(target_id, true)

func _on_body_exited(body):
	if body.is_in_group("player"):
		tilemap.trigger_door(target_id, false)
