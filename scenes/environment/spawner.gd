extends Sprite2D

func _ready() -> void:
	if get_tree().get_node_count_in_group(&"player") > 0:
		for player in get_tree().get_nodes_in_group(&"player"):
			if not player.is_replaying:
				player.global_position = global_position
				player.start_pos = player.position
