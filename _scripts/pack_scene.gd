extends Node3D
class_name PackScene

var selected: Packable
@onready var box_area: Area3D = $BoxArea
@onready var fence_area: Area3D = $FenceArea


func _ready() -> void:
	for child: Packable in $Packables.get_children():
		child.register_in_scene(self)
		child.selected.connect(func(): change_selected(child))


func _process(delta: float) -> void:
	pass
	
	
func check_all_in() -> void:
	for child: Packable in $Packables.get_children():
		if !child.inside(): return
	print("level won")


func change_selected(p_selected: Packable) -> void:
	if selected==p_selected: return
	
	if selected: selected.deselected.emit()
	selected=p_selected
