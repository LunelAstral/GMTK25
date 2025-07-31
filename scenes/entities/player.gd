extends CharacterBody2D
class_name Player

const player_scene := preload("res://scenes/entities/player.tscn")

@onready var tilemap: TileMapLayer = get_parent()

var speed = 5

var is_replaying := false
var move_target: Vector2
var is_moving := false

var start_pos = null

var moves_recording = []

enum moves {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

func _process(delta):
	if is_moving:
		# Move to move_target
		position = position.move_toward(move_target, speed)
		if position == move_target:
			is_moving = false

func replay():
	if is_replaying and moves_recording.size() > 0:
		var move = moves_recording.pop_front()
		var dir : Vector2
		if move == moves.UP:
			dir = Vector2.UP
		elif move == moves.DOWN:
			dir = Vector2.DOWN
		elif move == moves.LEFT:
			dir = Vector2.LEFT
		elif move == moves.RIGHT:
			dir = Vector2.RIGHT
		
		move_target = get_move_target(dir)
		is_moving = true

func _ready():
	GameGlobalEvents.tick.connect(replay)
	start_pos = position

func _input(event: InputEvent) -> void:
	if is_moving or is_replaying:
		return
		
	var dir := Vector2.ZERO
	
	var to_move = null
	
	if event.is_action_pressed("Replay"):
		var clone = player_scene.instantiate()
		clone.position = start_pos
		clone.is_replaying = true
		clone.moves_recording = moves_recording.duplicate(true)
		add_sibling(clone)
	elif event.is_action_pressed("Up"):
		dir = Vector2.UP
		to_move = moves.UP
	elif event.is_action_pressed("Down"):
		dir = Vector2.DOWN
		to_move = moves.DOWN
	elif event.is_action_pressed("Left"):
		dir = Vector2.LEFT
		to_move = moves.LEFT
	elif event.is_action_pressed("Right"):
		dir = Vector2.RIGHT
		to_move = moves.RIGHT

	if dir != Vector2.ZERO:
		var next = get_next_tile(dir)
		
		if next.size() > 0:
			if next[0].collider.is_in_group("solid"): 
				print("Blocked")
				print(next[0].collider.get_node("CollisionShape2D").disabled)
				return  # Blocked
				
			#if next[0].collider is Object_Interactable: 
				#for i in range(next.size()):
					#next[i].get("collider").overlap(self)

		# Record this move, then perform it
		moves_recording.append(to_move)
		move_target = get_move_target(dir)
		is_moving = true
		GameGlobalEvents.tick.emit()
			
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
