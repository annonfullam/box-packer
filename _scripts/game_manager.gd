extends Node
class_name GameManager

@export var level: Level

@export var packable_manager: Packables_Manager

@export var win_scene: PackedScene
var curr_win_scene: Node

var box_area: Area3D
var fence_area: Area3D

signal level_won
var count_time: bool = true

func _ready():
	if level:
		var area_array: Array[Area3D] = level.create_box(packable_manager)
		box_area = area_array[0]
		fence_area = area_array[1]
	
		level.populate_level(packable_manager)


func _process(delta: float) -> void:
	if count_time: Global.Level_Time += delta


func check_all_in() -> void:
	if packable_manager.current_selection != null:
		return
	
	for child: Packable in packable_manager.packables:
		if not child.inside(): return
	
	complete_level()


func complete_level():
	if curr_win_scene:
		return
	
	var new_node: Node = win_scene.instantiate()
	owner.add_child(new_node)
	curr_win_scene = new_node
	
	count_time = false
	level_won.emit()
