extends Node

var INPUT: InputHandler = null
var LEVEL: Level = null


var LEVEL_COUNT: int
func _ready() -> void:
	LEVEL_COUNT = Helpers.get_files_in_dir("res://scenes/levels/").size()
