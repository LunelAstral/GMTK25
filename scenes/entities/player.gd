## The player for the game, pretty much all of the player functionality is here.
class_name Player extends CharacterBody2D

const player_scene := preload("res://scenes/entities/player.tscn")

# TODO: Start cleaning up code and documenting to make things easier to read. (Lunel can do this)
# TODO: Implement LOOP charge functionality: premise is having multiple replay sets, and when you switch to an
# empty one instead of the currently recorded set, when you "loop" the prior recording is still there instead
# of being deleted like usual. This is where the new recording starts so that when you hit loop on that one you'll
# have two looped versions of yourself alongside the present you.

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
var is_grounded := true

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

func _process(_delta: float) -> void:
	if position != move_target:
		position = position.move_toward(move_target, _delta*speed)
	if can_act:
		movement_input()
	
	animate()

func _input(event: InputEvent) -> void:
	if is_replaying or not can_act:
		return
	
	if event.is_action_pressed("Wait"):
		moves_recorded.append(Actions.WAIT)
		end_input()
		return
	
	if event.is_action_pressed("Replay"):
		begin_loop()
		
#endregion

func movement_input() -> void:
	if is_replaying:
		return
		
	if Input.is_action_pressed("Wait"):
		return
		
	var init_move_size : int = moves_recorded.size()
	
	var dir := Input.get_vector("Left", "Right", "Up", "Down")
	
	if boost_duration != 0:
		dir = self.boost_direction
		self.boost_duration -= 1
		if self.boost_duration == 0:
			self.is_grounded = true
		
	facing = dir
	
	if dir != Vector2.ZERO:
		var next = get_next_tile(dir)
		
		
		
		if next:
			if self.is_grounded:
				if next.get_custom_data("is_spring"):
					self.spring(next.get_custom_data("boost_direction"),next.get_custom_data("boost_duration"))
				
				elif next.get_custom_data("boost_duration") != 0:
					self.boost(next.get_custom_data("boost_direction"),next.get_custom_data("boost_duration"))
				
				elif next.get_custom_data("is_spike"):
					begin_loop()
				
			elif next.get_custom_data("solid"): 
					self.boost_duration = 0
					return  # Blocked
		
		# Record this move, then perform it
		moves_recorded.append(dir)
		move_target = get_move_target(dir)
	
	if init_move_size != moves_recorded.size():
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
				
				
				
	#FIXME: Need to make it so that the animations dont play unless the player is moving 
	if Input.is_action_pressed("Wait"):
		sprite.pause()
	else:
		sprite.play()

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

func get_next_tile(dir) -> TileData:
	var current_tile := tilemap.local_to_map(position)
	var target_tile := current_tile + Vector2i(dir)
	var target_world_pos := tilemap.map_to_local(target_tile)
	
	return tilemap.get_cell_tile_data(target_tile)

func end_input() -> void:
	#print("Recorded:", moves_recorded)
	GameGlobalEvents.tick.emit()
	can_act = false
	await GameGlobal.delay(step_delay)
	can_act = true
#endregion

func boost(direction, duration):
	self.boost_direction = direction
	self.boost_duration = duration
	
func spring(direction, duration):
	self.is_grounded = false
	self.boost(direction, duration)

func begin_loop():
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

# TODO players should loop a wait command once their loop is over
