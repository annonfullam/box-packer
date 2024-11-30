extends Node3D
class_name Packable

signal selected
signal deselected

@onready var collider: RigidBody3D = $".."

var start_pos_and_rot: Dictionary

func register_in_scene(manager: GameManager) -> void:
	manager.box_area.body_entered.connect(func(body: Node3D):
		if body != collider: return
		_in_box = true
		manager.check_all_in())
	manager.fence_area.body_exited.connect(func(body: Node3D):
		if body != collider: return
		_in_fence = false
		manager.check_all_in())
	manager.box_area.body_exited.connect(func(body: Node3D):
		if body != collider: return
		_in_box = false)
	manager.fence_area.body_entered.connect(func(body: Node3D):
		if body != collider: return
		_in_fence = true)


func _ready() -> void:
	collider.set_collision_layer_value(2, true) # raycasting


func respawn() -> void:
	# Why does it disable the collider's process?
	var prev_process_type = collider.process_mode
	collider.process_mode = Node.PROCESS_MODE_DISABLED
	
	collider.global_position = start_pos_and_rot.position
	collider.global_rotation_degrees = start_pos_and_rot.rotation
	collider.linear_velocity = Vector3(0,0,0)
	collider.angular_velocity = Vector3(0,0,0)
	
	collider.process_mode = prev_process_type


var _in_box: bool = false
var _in_fence: bool = false
func inside() -> bool: return not _in_fence && _in_box
