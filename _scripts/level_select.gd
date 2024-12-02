extends Control


func go_to_level(scene_name: String, level_name: String):
	var new_scene: Node = SceneManager.change_scene(scene_name, true)
	var game_manager: GameManager = new_scene.get_node("GameManager")
	
	await SceneManager.change_scene
	var level_data: Level = load("res://scenes/levels/" + level_name + ".tres")
	game_manager.init_level(level_data)


func _on_button_10_pressed() -> void:
	go_to_level("factory_scene", "1-0")
