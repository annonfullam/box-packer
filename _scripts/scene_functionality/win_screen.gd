extends Control

@onready var time_label: Label = $TimeLabel

@onready var retry_button: Button = $RetryButton
@onready var level_select_button: Button = $LevelSelectButton
@onready var next_level_button: Button = $NextLevelButton
@onready var main_menu_button: Button = $MainMenuButton


func _ready() -> void:
	time_label.text += " " + str(round(GlobalReferences.Current_Level.time_to_beat * 100) / 100) + " seconds"
	
	retry_button.connect("pressed", func(): 
		var game_manager: GameManager = get_parent().find_child("GameManager")
		if game_manager: game_manager.restart_level())
	level_select_button.connect("pressed", func(): SceneManager.change_scene("level_select"))
	next_level_button.connect("pressed", func(): print("Nothing yet"))
	main_menu_button.connect("pressed", func(): SceneManager.change_scene("main_menu"))
