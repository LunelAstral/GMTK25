extends Object_Interactable

@export var exit_node : Object_Interactable

var can_interact := true

func _ready() -> void:
	super()
	body_exited.connect(_on_body_exited)

func overlap(_player : Player) -> void:
	if "can_interact" in exit_node:
		if can_interact:
			exit_node.can_interact = false
			_player.position = exit_node.position
			_player.move_target = _player.position
	else:
		push_warning("The connected exit_node is not a teleporter.")

func _on_body_exited(node: Node2D) -> void:
	if node is Player and not can_interact:
		can_interact = true
