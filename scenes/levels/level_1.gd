extends TileMapLayer

func _ready() -> void:
	MusicManager.play_song(&"ost_stage_1")
