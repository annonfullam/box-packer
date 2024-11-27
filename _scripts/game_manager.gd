extends Node
class_name GameManager

@export var box_area: Area3D
@export var fence_area: Area3D


func check_all_in() -> void:
	for child: Packable in get_children():
		if not child.inside(): return
	
	complete_level()


func complete_level():
	print("level won")
