extends Node3D
class_name Packables_Manager

var current_selection: Packable
var packables: Array[Packable] = []

@onready var game_manager: GameManager = $"../GameManager"

func _ready() -> void:
	for child in get_children():
		var packable_component: Packable = child.get_node("Packable")
		if not packable_component:
			return
	
		packables.append(packable_component)
		packable_component.register_in_scene(game_manager)
		packable_component.selected.connect(func(_hit: Node3D):
			change_selected(_hit))


func change_selected(p_selected: Packable) -> void:
	if current_selection == p_selected:
		print("Already selected!")
		return
	
	if current_selection: current_selection.deselected.emit()
	current_selection = p_selected


func _input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return
	
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
		var hit: Dictionary = Global.cursor_raycast()
		if hit.has("collider"):
			print(hit.collider.name)
			current_selection.selected.emit(hit.collider.get_node("Packable"))
