extends Node
class_name GameManager

@export var packable_manager: PackablesManager

var LEVEL: Level


const win_scene: PackedScene = preload("res://scenes/win_screen.tscn")
const pause_menu: PackedScene = preload("res://scenes/pause_menu.tscn")


func start_level(l: Level):
	LEVEL = l
	
	LEVEL.ended.connect(end_level)
	LEVEL.ended.connect(func(): packable_manager.can_select = false)
	LEVEL.initialize(packable_manager)


func restart_level():
	var new_scene: Node = SceneManager.change_scene(LEVEL.background_scene_name)
	var game_manager: GameManager = new_scene.get_node("GameManager")
	
	game_manager.start_level(LEVEL)


func _process(delta: float) -> void:
	if LEVEL: LEVEL.update(delta)
	
	if Input.is_action_just_pressed("pause"): 
		Helpers.add_scene_to_parent(self, pause_menu)
		get_tree().paused = true


# This function needs to be connected to the packables-manager check all packed fuinction in some way
func end_level():
	var new_node: Node = win_scene.instantiate()
	owner.add_child(new_node)
