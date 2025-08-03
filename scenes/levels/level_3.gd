extends TileMapLayer

func _ready() -> void:
	MusicManager.play_song(&"stage_4_theme")
