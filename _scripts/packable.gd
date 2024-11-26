extends Node3D
class_name Packable

var scene: PackScene
func register_in_scene(p_scene: PackScene):
	scene=p_scene
	
func on_click(camera: Camera3D, event: InputEvent, event_position: Vector3, 
		normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("clicked on me!")
		
func _ready() -> void:
	$RigidBody3D.connect("input_event", on_click)
