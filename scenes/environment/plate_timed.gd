extends Plate


func overlap(_player: Player):
	super(_player)
	$Sprite2D.frame  = 19
	
	
func exit(_player: Player):
	super(_player)	
	
	if not get_overlapping_bodies():
		target_door.is_open = true
		$Sprite2D.frame = 16
	
# TODO change exit so instead of instantly turning back on, it waits for 3 calls to this tick
	
func tick():
	if $Sprite2D.frame == 18:
		$Sprite2D.frame = 15
		target_door.is_open = false
	else:
		$Sprite2D.frame += 1
