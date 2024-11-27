extends Node3D
class_name Packable

var is_selected: bool = false

signal selected
@warning_ignore("unused_signal") signal deselected

@onready var rigidbody: RigidBody3D = $".."


func register_in_scene(manager: GameManager) -> void:
	manager.box_area.body_entered.connect(func(body: Node3D):
		if body != rigidbody: return
		_in_box = true
		manager.check_all_in())
	manager.fence_area.body_exited.connect(func(body: Node3D):
		if body != rigidbody: return
		_in_fence = false
		manager.check_all_in())
	manager.box_area.body_exited.connect(func(body: Node3D):
		if body != rigidbody: return
		_in_box = false)
	manager.fence_area.body_entered.connect(func(body: Node3D):
		if body != rigidbody: return
		_in_fence = true)


var _in_box: bool = false
var _in_fence: bool = false
func inside() -> bool: return !_in_fence && _in_box

# TODO: Raycast detect this object instead of input event. The box areas will block it.
func on_click(camera: Camera3D, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	print("on click")
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("selected")
		selected.emit()
		#is_selected = true
