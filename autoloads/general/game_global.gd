## The actual Global containing all of the game's core information.
extends Node

#region Built-Ins
func _ready() -> void:
	# Loading up sounds and then deleting the sound_loader as it's no longer necessary
	var sound_loader = SoundLoader.new()
	sound_loader.load_audio()
	sound_loader = null
#endregion

#region Helpers
func delay(time: float) -> void:
	await get_tree().create_timer(time).timeout
#endregion

# TODO: Putting a few todos here since I don't have much time to set up the files.
# TODO: Need a teleporter pad for the player, connected via an export
# TODO: Need a spring pad that will "launch" the player to usually unreachable areas.
# TODO: Need a boost pad that will send players in one direction, either until a wall hit or after a certain
# amount of tiles.
