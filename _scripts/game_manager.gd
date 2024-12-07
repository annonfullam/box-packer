extends Node
class_name GameManager

@export var packable_manager: Packables_Manager

@export var win_scene: PackedScene
var curr_win_scene: Node

const pause_menu: PackedScene = preload("res://scenes/pause_menu.tscn")

var box_area: Area3D
var fence_area: Area3D

signal level_initialized
signal level_won

var level: Level
var count_time: bool = false


func init_level(lvl: Level):
	level = lvl
	
	var area_array: Array[Area3D] = lvl.create_box(packable_manager)
	box_area = area_array[0]
	fence_area = area_array[1]

	GlobalReferences.Current_Level = level
	level.populate_level(packable_manager)
	

	level_initialized.emit()


func restart_level():
	var new_scene: Node = SceneManager.change_scene(level.background_scene_name)
	var game_manager: GameManager = new_scene.get_node("GameManager")
	
	game_manager.init_level(level)

var current_pause_menu: Control
func _process(delta: float) -> void:
	if count_time: level.time_to_beat += delta
	
	# Pause menu but jerry rigged
	if Input.is_action_just_pressed("escape"):
		if current_pause_menu and current_pause_menu.visible: 
			queue_free()
			return
		var npause_menu: Control = pause_menu.instantiate()
		add_child(npause_menu)
		
		current_pause_menu = npause_menu
		npause_menu.show()



func check_all_in() -> void:
	if packable_manager.current_selection != null:
		return
	
	for child: Packable in packable_manager.packables:
		if not child.inside(): return
	
	complete_level()

# This function might be better off in the actual level resource
func complete_level():
	if curr_win_scene:
		return
	
	var new_node: Node = win_scene.instantiate()
	owner.add_child(new_node)
	curr_win_scene = new_node
	
	count_time = false
	level_won.emit()
