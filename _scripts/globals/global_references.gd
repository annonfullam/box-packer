extends Node

var INPUT: InputHandler = null
var LEVEL: Level = null

var PLAYER_DATA: PlayerData = PlayerData.new()

var LEVEL_COUNT: int
func _ready() -> void:
	LEVEL_COUNT = Helpers.get_files_in_dir("res://scenes/levels/").size()
	PLAYER_DATA.best_times.resize(LEVEL_COUNT)
