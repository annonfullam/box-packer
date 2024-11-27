extends Node3D
class_name Packables_Manager

var current_selection: Packable
var packables: Array[Packable] = []
@export var in_bounds: Area3D

@onready var game_manager: GameManager = $"../GameManager"

func _ready() -> void:
	for child in get_children():
		var packable_component: Packable = child.get_node("Packable")
		if not packable_component:
			return
	
		packables.append(packable_component)
		packable_component.register_in_scene(game_manager)
		packable_component.selected.connect(func(hit: Dictionary):
			current_selection = hit.collider.find_child("Packable"))
	in_bounds.body_exited.connect(func(node: Node3D):
		var child = node.find_child("Packable")
		if child: child.respawn())


func _input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return
	
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var hit: Dictionary = Global.cursor_raycast()
			if hit.has("collider"):
				var child = hit.collider.find_child("Packable")
				if child: child.selected.emit(hit)
		elif current_selection:
			current_selection.deselected.emit()
			current_selection=null
