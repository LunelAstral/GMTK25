extends Plate

@export var delay : int = 3
var delay_timer : int = 0
var can_count_down := false
var reset_cooldown := false

func overlap(_player: Player):
	super(_player)

func reset() -> void:
	delay_timer = 0
	can_count_down = false
	reset_cooldown = true
	super()

func exit(_player: Player):
	if not get_overlapping_bodies() and not reset_cooldown:
		delay_timer = 3
		can_count_down = true
	
func tick():
	if sprite.frame == 4 and delay_timer > 0:
		delay_timer -= 1
	elif sprite.frame == 4 and can_count_down:
		can_count_down = false
	elif not can_count_down and sprite.frame == 4:
		sprite.frame = 0
		target_door.is_open = false
		SoundManager.play_sound("pressure_plate_deactivating")
	elif can_count_down:
		sprite.frame += 1
	
	if reset_cooldown:
		reset_cooldown = false
