extends Node3D
class_name Packables_Manager

var selected: Packable

@onready var game_manager: GameManager = $"../GameManager"

func _ready() -> void:
	for child in get_children():
		var packable_component: Packable = child.get_node("Packable")
		if not packable_component:
			return

		packable_component.register_in_scene(game_manager)
		packable_component.selected.connect(func(): change_selected(packable_component))


func change_selected(p_selected: Packable) -> void:
	if selected == p_selected: 
		print("already selected!")
		return
	
	if selected: selected.deselected.emit()
	selected = p_selected
	print(selected.name)
