extends Node
class_name GameManager

@export var box_area: Area3D
@export var fence_area: Area3D

@export var packable_manager: Packables_Manager

# FIXME: We need to change where this function is called because it gets called for each packable object in the box.
# Possibly every x seconds after a certain amount of objects have been spawned?
func check_all_in() -> void:
	for child: Packable in packable_manager.packables:
		if not child.inside(): return
	
	complete_level()


func complete_level():
	print("level won")
