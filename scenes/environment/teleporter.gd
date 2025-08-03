extends Object_Interactable

@export var exit_node : Object_Interactable

var can_interact := true

func _ready() -> void:
	super()

func overlap(_player : Player) -> void:
	if "can_interact" in exit_node:
		if can_interact:
			match(randi_range(0, 1)):
				0:
					SoundManager.play_sound(&"teleporting")
				1:
					SoundManager.play_sound(&"teleporting_2")
			exit_node.can_interact = false
			_player.position = exit_node.position
			_player.move_target = _player.position
	else:
		push_warning("The connected exit_node is not a teleporter.")

func exit(player: Player) -> void:
	if not can_interact:
		can_interact = true
