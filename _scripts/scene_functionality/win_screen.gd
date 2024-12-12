extends Control

@onready var time_label: Label = $TimeLabel

@onready var retry_button: Button = $RetryButton
@onready var level_select_button: Button = $LevelSelectButton
@onready var next_level_button: Button = $NextLevelButton
@onready var main_menu_button: Button = $MainMenuButton

func _ready() -> void:
	time_label.text += " " + str(round(GlobalReferences.LEVEL.time * 100) / 100) + " seconds"
	$BestTimeLabel.text += " " + str(round(GlobalReferences.LEVEL.best_time * 100) / 100) + " seconds"
	
	var game_manager: GameManager = get_parent().find_child("GameManager")
	var next_level: Level = load("res://scenes/levels/" + str(game_manager.LEVEL.level_id + 1) + ".tres")
	
	if game_manager.LEVEL.level_id + 1 > GlobalReferences.LEVEL_COUNT: next_level_button.disabled = true
	
	retry_button.connect("pressed", func(): if game_manager: game_manager.restart_level())
	
	level_select_button.connect("pressed", func(): 
		var main_menu: MainMenu = SceneManager.change_scene("main_menu").get_node("MainMenuUI")
		main_menu.open_level_select())
		
	next_level_button.connect("pressed", func(): 
		var new_scene: Node = SceneManager.change_scene(next_level.background_scene_name)
		new_scene.get_node("GameManager").start_level(next_level))
		
	main_menu_button.connect("pressed", func(): SceneManager.change_scene("main_menu"))
