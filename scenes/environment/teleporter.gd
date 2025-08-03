extends Object_Interactable

@export var exit : Object_Interactable

var can_interact := true

func _ready() -> void:
	super()
	body_exited.connect(_on_body_exited)

func overlap(player : Player) -> void:
	if "can_interact" in exit:
		if can_interact:
			exit.can_interact = false
			player.position = exit.position
			player.move_target = player.position
	else:
		push_warning("The connected exit is not a teleporter.")

func _on_body_exited(node: Node2D) -> void:
	if node is Player and not can_interact:
		can_interact = true
