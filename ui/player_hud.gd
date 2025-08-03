extends CanvasLayer

@export var loop_charges : Label
@export var focused_record : Label

func _process(delta: float) -> void:
	if loop_charges:
		loop_charges.text = "%s" % GameGlobal.player.loop_charge
	
	if focused_record:
		focused_record.text = "%s" % (GameGlobal.player.record_focused + 1)
