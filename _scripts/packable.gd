extends Node3D
class_name Packable

var scene: PackScene
var _in_box: bool = false
var _in_fence: bool = false
signal selected
signal deselected

func inside() -> bool: return !_in_fence && _in_box

@onready var rigidbody: RigidBody3D = $RigidBody3D
func register_in_scene(p_scene: PackScene) -> void:
	scene=p_scene
	
	scene.box_area.body_entered.connect(func(body: Node3D):
		if body != rigidbody: return
		_in_box=true
		scene.check_all_in())
	scene.fence_area.body_exited.connect(func(body: Node3D):
		if body != rigidbody: return
		_in_fence=false
		scene.check_all_in())
	scene.box_area.body_exited.connect(func(body: Node3D):
		if body != rigidbody: return
		_in_box=false)
	scene.fence_area.body_entered.connect(func(body: Node3D):
		if body != rigidbody: return
		_in_fence=true)

func on_click(camera: Camera3D, event: InputEvent, event_position: Vector3, 
		normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		selected.emit()
		
func _ready() -> void:
	rigidbody.connect("input_event", on_click)
	
func _process(delta: float) -> void:
	pass
