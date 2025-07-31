extends Object_Interactable

@export var connected_checkpoints : Array[Object_Interactable]

func _ready() -> void:
	$Sprite2D.hide()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("Player entered!")
		body.start_pos = position
	
	for player in get_tree().get_nodes_in_group(&"player"):
		if player.is_replaying:
			player.queue_free()
		else:
			player.moves_recorded = []
	
	for checkpoints in connected_checkpoints:
		queue_free()
	
	queue_free()
