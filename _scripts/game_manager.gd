extends Node
class_name GameManager

@export var packable_manager: Packables_Manager

var box_area: Area3D
var fence_area: Area3D

signal level_initialized
signal level_won

var level: Level

const win_scene: PackedScene = preload("res://scenes/win_screen.tscn")
var curr_win_scene: Node = null
const pause_menu: PackedScene = preload("res://scenes/pause_menu.tscn")

func init_level(lvl: Level):
	level = lvl
	
	var area_array: Array[Area3D] = lvl.create_box(packable_manager)
	box_area = area_array[0]
	fence_area = area_array[1]

	GlobalReferences.current_level = level
	level.populate_level(packable_manager)
	
	level_initialized.emit()

var count_time: bool = false
func _process(delta: float) -> void:
	if count_time: level.time += delta
	
	if Input.is_action_just_pressed("pause"): 
		Helpers.add_scene_to_parent(self, pause_menu)
		get_tree().paused = true


func restart_level():
	var new_scene: Node = SceneManager.change_scene(level.background_scene_name)
	var game_manager: GameManager = new_scene.get_node("GameManager")
	
	game_manager.init_level(level)


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
