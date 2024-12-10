extends Control


func _ready() -> void:
	$MainMenuButton.connect("pressed", func(): 
		SceneManager.change_scene("main_menu")
		get_tree().paused = false)
	
	$ResumeButton.connect("pressed", unpause)



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		unpause()


func unpause():
	get_tree().paused = false
	queue_free()
