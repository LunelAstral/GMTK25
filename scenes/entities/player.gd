## The player for the game, pretty much all of the player functionality is here.
class_name Player extends CharacterBody2D

const player_scene := preload("res://scenes/entities/player.tscn")

# TODO: Start cleaning up code and documenting to make things easier to read. (Lunel can do this)
@export_category("Node References")
@export var sprite : AnimatedSprite2D

@export_category("Variables")
@export var step_delay : float = 0.15
@export var despawn_delay : int = 3
@export var spawn_point : Object_Interactable
@export var speed := 80
@export var facing := Vector2.DOWN

var boost_duration := 0
var boost_direction: Vector2
var loop_charge : int = 1

var is_replaying := false
var move_target: Vector2
var can_act := true
var sprung := false

var tilemap: TileMapLayer
var start_pos = Vector2.ZERO

var moves_recorded = [[]]
var record_focused : int = 0

enum Actions {
	WAIT,
	INTERACT
}

#region Built-Ins
func _ready():
	add_to_group(&"player")
	
	if is_replaying:
		GameGlobalEvents.tick.connect(replay)
	else:
		GameGlobal.player = self
	
	tilemap = get_parent() if get_parent() is TileMapLayer else null
	
	move_target = position
	start_pos = position

func _process(_delta: float) -> void:
	if moves_recorded.size() != loop_charge:
		check_records_size()
	
	if position != move_target:
		position = position.move_toward(move_target, _delta*speed)
	if can_act:
		movement_input()
	
	animate()

func _input(event: InputEvent) -> void:
	if is_replaying or not can_act:
		return
	
	if event.is_action_pressed("Wait"):
		record(Actions.WAIT)
		end_input()
		return
	
	if event.is_action_pressed("Replay"):
		begin_loop()
	
	if event.is_action_pressed("Record 1"):
		record_focused = 0
	elif event.is_action_pressed("Record 2"):
		if loop_charge > 1:
			if moves_recorded.size() < 2:
				moves_recorded.append([])
			record_focused = 1
	elif event.is_action_pressed("Record 3"):
		if loop_charge > 2:
			if moves_recorded.size() < 3:
				for i in range(3 - moves_recorded.size()):
					moves_recorded.append([])
			record_focused = 2
#endregion

func movement_input() -> void:
	if is_replaying:
		return
	
	var init_move_size : int = moves_recorded.get(record_focused).size()
	
	var dir := Input.get_vector("Left", "Right", "Up", "Down")
	
	if boost_duration != 0:
		dir = self.boost_direction
		self.boost_duration -= 1
		if self.boost_duration == 0:
			self.sprung = false
		
	facing = dir
	
	if dir != Vector2.ZERO:
		var next = get_next_tile(dir)
		
		if next:
			if next.get_custom_data("is_spike") and not sprung:
				moves_recorded = []
				check_records_size()
				position = start_pos
				move_target = start_pos
				dir = Vector2.ZERO
				return
			elif next.get_custom_data("solid") and not sprung: 
					self.boost_duration = 0
					return  # Blocked
		else:
			var target_pos = get_move_target(dir)
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsPointQueryParameters2D.new()
			query.position = tilemap.to_global(target_pos)
			query.collide_with_areas = true
			var result = space_state.intersect_point(query)
			
			if result.size() > 0:
				for res in result:
					if "is_open" in res.collider:
						if not res.collider.is_open:
							return
		
		# Record this move, then perform it
		record(dir)
		move_target = get_move_target(dir)
	
	if init_move_size != moves_recorded.get(record_focused).size():
		end_input()

func animate() -> void:
	if facing.x != 0 and facing.y != 0:
		facing.x = 0
	
	facing = facing.normalized()
	
	match(facing):
		Vector2(1, 0):
			if sprite.animation != "side" or not sprite.flip_h:
				sprite.flip_h = true
				sprite.animation = "side"
		Vector2(-1, 0):
			if sprite.animation != "side" or sprite.flip_h:
				sprite.flip_h = false
				sprite.animation = "side"
		Vector2(0, 1):
			if sprite.animation != "down":
				sprite.flip_h = false
				sprite.animation = "down"
		Vector2(0, -1):
			if sprite.animation != "up":
				sprite.flip_h = false
				sprite.animation = "up"
				
	
	if Input.is_action_pressed("Wait"):
		sprite.pause()
	else:
		sprite.play()

#region Timey-Wimey
func replay() -> void:
	if moves_recorded.get(0).size() > 0:
		var move = moves_recorded.get(0).pop_front()
		
		if move is Vector2:
			move_target = get_move_target(move)
#			if self.sprung:
#				GameGlobalEvents.tick.emit()
		elif move is Actions:
			if move == Actions.WAIT:
				return
	elif moves_recorded.get(0).size() == 0:
		for i in range(despawn_delay):
			await GameGlobalEvents.tick
		queue_free()
#endregion

#region Helpers
func get_move_target(dir):
	var current_tile: Vector2i = tilemap.local_to_map(position)
	var target_tile: Vector2i = current_tile + Vector2i(dir)
	return tilemap.map_to_local(target_tile)

func get_next_tile(dir) -> TileData:
	var current_tile := tilemap.local_to_map(position)
	var target_tile := current_tile + Vector2i(dir)
	
	return tilemap.get_cell_tile_data(target_tile)

func end_input() -> void:
	GameGlobalEvents.tick.emit()
	can_act = false
	await GameGlobal.delay(step_delay)
	can_act = true
#endregion

func boost(direction, duration):
	self.boost_direction = direction
	self.boost_duration = duration
	
func spring(direction, duration):
	self.sprung = true
	self.boost(direction, duration)

func begin_loop():
		position = start_pos
		move_target = position
		
		for player in get_tree().get_nodes_in_group(&"player"):
			if player.is_replaying:
				player.queue_free()
		
		for i in moves_recorded:
			var clone = player_scene.instantiate()
			create_loop(clone, i)
		
		if record_focused == loop_charge - 1:
			moves_recorded = []
			for i in range(loop_charge):
				moves_recorded.append([])
		else:
			record_focused += 1
		end_input()
		GameGlobalEvents.looped.emit()
		return

func create_loop(clone: Player, moves: Array[Variant]) -> void:
		clone.position = start_pos
		clone.is_replaying = true
		clone.moves_recorded = [moves.duplicate(true)]
		clone.moves_recorded.get(0).insert(0, Actions.WAIT)  # Prepend dummy move so it starts at same point
		add_sibling(clone)

# TODO players should loop a wait command once their loop is over

func record(action: Variant) -> void:
	moves_recorded.get(record_focused).append(action)

func check_records_size() -> void:
	for i in range(loop_charge):
		if moves_recorded.size() < i + 1:
			moves_recorded.append([])
