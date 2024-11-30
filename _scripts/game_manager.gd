extends Node
class_name GameManager

@export var box_area: Area3D
@export var fence_area: Area3D

@export var packable_manager: Packables_Manager

@export var win_scene: PackedScene
var curr_win_scene: Node

func _ready():
	#if Global.Kinematic_Box: box_area.get_parent().get_node("Rigidbody3D").freeze = false
	pass


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
	
