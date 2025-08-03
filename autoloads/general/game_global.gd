## The actual Global containing all of the game's core information.
extends Node

var player : Player

#region Helpers
func delay(time: float) -> void:
	await get_tree().create_timer(time).timeout
#endregion

# TODO going to another level
