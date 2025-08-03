## The Main Interactable object class, pretty much anything within the game that can be interacted
## with uses this code.
extends Area2D
class_name Object_Interactable

var tilemap : TileMapLayer

# Make sure anything extending this class is a child of the tilemap
func _ready() -> void:
	if get_parent() is TileMapLayer:
		tilemap = get_parent()
	else:
		push_warning("This node works better with a tilemap set to parent.")
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	GameGlobalEvents.tick.connect(tick)
	GameGlobalEvents.looped.connect(reset)

func tick() -> void:
	pass

func reset() -> void:
	pass

func overlap(_player : Player) -> void:
	pass
	
func exit(_player: Player) -> void:
	pass

func _on_body_entered(node: Node2D) -> void:
	if node is Player:
		overlap(node)


func _on_body_exited(node: Node2D) -> void:
	if node is Player:
		exit(node)
