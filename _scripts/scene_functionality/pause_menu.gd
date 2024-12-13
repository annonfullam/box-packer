extends Control


func _ready() -> void:
	$VBoxContainer/ResumeButton.connect("pressed", unpause)
	
	$VBoxContainer/SettingsButton.connect("pressed", func():
		var new_scene: Node = SceneManager.add_scene("settings_menu", get_parent())
		new_scene.get_node("BackButton").connect("pressed", func():
			new_scene.queue_free()
			show())
		hide())
	$VBoxContainer/LevelSelectButton.connect("pressed", func():
		SceneManager.change_scene("level_select")
		unpause())
	
	$VBoxContainer/MainMenuButton.connect("pressed", func(): 
		SceneManager.change_scene("main_menu")
		unpause())




func _process(delta: float) -> void:
	if visible and Input.is_action_just_pressed("pause"):
		unpause()


func unpause():
	get_tree().paused = false
	queue_free()
