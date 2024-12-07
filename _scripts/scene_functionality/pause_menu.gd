extends Control


func _ready() -> void:
	$MainMenuButton.connect("pressed", func(): SceneManager.change_scene("main_menu"))
