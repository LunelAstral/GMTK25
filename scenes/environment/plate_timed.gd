extends Plate





func overlap(_player: Player):
	super(_player)
	$Sprite2D.animation.frame  = 19
	
	
func exit(_player: Player):
	super(_player)
	if target_door.is_open:
		target_door.is_open = true
		$Sprite2D.animation.free = 16
	
# TODO change exit so instead of instantly turning back on, it waits for 3 calls to this tick
	
func tick():
	if $Sprite2D.animation.frame == 18:
		$Sprite2D.animation.frame = 19
		target_door.is_open = false
	else:
		$Sprite2D.animation.frame += 1
