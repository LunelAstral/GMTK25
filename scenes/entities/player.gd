class_name Player extends CharacterBody2D

const player_scene := preload("res://scenes/entities/player.tscn")

@export var step_delay : float = 0.15
@export var despawn_delay : int = 3
@export var spawn_point : Object_Interactable
@export var speed := 80

var is_replaying := false
var move_target: Vector2
var can_act := true

var tilemap: TileMapLayer
var start_pos = Vector2.ZERO

var moves_recorded = []

enum Actions {
	WAIT,
	INTERACT
}

#region Built-Ins
func _ready():
	if is_replaying:
		GameGlobalEvents.tick.connect(replay)
	
	tilemap = get_parent() if get_parent() is TileMapLayer else null
	
	move_target = position
	start_pos = position

# FIXME: Need to figure out why "Wait" and holding down input fucks with recording.
func _process(_delta: float) -> void:
	if position != move_target:
		position = position.move_toward(move_target, _delta*speed)
	if can_act:
		movement_input()

func _input(event: InputEvent) -> void:
	if is_replaying or not can_act:
		return
	
	if event.is_action_pressed("Wait"):
		moves_recorded.append(Actions.WAIT)
		end_input()
		return
	
	if event.is_action_pressed("Replay"):
		position = start_pos
		move_target = position
		
		var clone = player_scene.instantiate()
		clone.position = start_pos
		clone.is_replaying = true
		clone.moves_recorded = moves_recorded.duplicate(true)
		clone.moves_recorded.insert(0, Actions.WAIT)  # Prepend dummy move so it starts at same point
		moves_recorded = []
		add_sibling(clone)
		end_input()
		return
		
#endregion

func movement_input() -> void:
	if is_replaying:
		return
		
	var init_move_size : int = moves_recorded.size()
	
	var dir := Input.get_vector("Left", "Right", "Up", "Down")
	
	if dir != Vector2.ZERO:
		var next = get_next_tile(dir)
		
		if next.size() > 0:
			if next[0].collider.is_in_group("solid"): 
				print(next[0].collider.get_node("CollisionShape2D").disabled)
				return  # Blocked
				
			#if next[0].collider is Object_Interactable: 
				#for i in range(next.size()):
					#next[i].get("collider").overlap(self)
		
		# Record this move, then perform it
		moves_recorded.append(dir)
		move_target = get_move_target(dir)
	
	if init_move_size != moves_recorded.size():
		end_input()

#region Timey-Wimey
func replay() -> void:
	if moves_recorded.size() > 0:
		var move = moves_recorded.pop_front()
		
		if move is Vector2:
			move_target = get_move_target(move)
		elif move is Actions:
			if move == Actions.WAIT:
				return
	elif moves_recorded.size() == 0:
		for i in range(despawn_delay):
			await GameGlobalEvents.tick
		queue_free()
#endregion

#region Helpers
func get_move_target(dir):
	var current_tile: Vector2i = tilemap.local_to_map(position)
	var target_tile: Vector2i = current_tile + Vector2i(dir)
	return tilemap.map_to_local(target_tile)

func get_next_tile(dir) -> Array[Dictionary]:
	var current_tile := tilemap.local_to_map(position)
	var target_tile := current_tile + Vector2i(dir)
	var target_world_pos := tilemap.map_to_local(target_tile)
	
	# HACK: See if there's a wall (or anything else) by checking against a point for collision
	# I really feel like we should use a matrix on the tilemap instead, but I leave it up to you
	var params := PhysicsPointQueryParameters2D.new()
	params.position = target_world_pos
	params.collision_mask = 1  # collision mask of walls
	params.collide_with_areas = true
	params.collide_with_bodies = true

	var space_state := get_world_2d().direct_space_state
	var results := space_state.intersect_point(params)
	
	return results

func end_input() -> void:
	print("Recorded:", moves_recorded)
	GameGlobalEvents.tick.emit()
	can_act = false
	await GameGlobal.delay(step_delay)
	can_act = true
#endregion
