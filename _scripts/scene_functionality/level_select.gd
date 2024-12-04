extends Control
class_name LevelSelect

@onready var level_button: Button = $LevelButton

@onready var right_button: Button = $RightButton
@onready var left_button: Button = $LeftButton


var current_level_selection: int = 1
var level_count: int


func _ready() -> void:
	right_button.connect("pressed", func(): change_level_selection(1))
	left_button.connect("pressed", func(): change_level_selection(-1))
	
	level_button.connect("pressed", go_to_level)
	
	# Get number of level files in levels folder
	level_count = Helpers.get_files_in_dir("res://scenes/levels/").size()


func change_level_selection(amt: int):
	if Input.is_action_pressed("shift"):
		amt *= 5
	
	current_level_selection += amt
	current_level_selection = clamp(current_level_selection, 1, level_count)
	
	level_button.text = str(current_level_selection)



func go_to_level():
	var level_data: Level = load("res://scenes/levels/" + str(current_level_selection) + ".tres")
	
	# Changes the scene
	var new_scene: Node = SceneManager.change_scene(level_data.background_scene_name)
	var game_manager: GameManager = new_scene.get_node("GameManager")
	
	game_manager.init_level(level_data)
