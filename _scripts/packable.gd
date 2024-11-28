extends Node3D
class_name Packable

signal selected
signal deselected

@onready var collider: RigidBody3D = $".."
@export var mesh_to_highlight: MeshInstance3D

var orig_pos_and_rot: Dictionary

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
	#selected.connect(func(_unused: Dictionary):
		#mesh_to_highlight.mesh.surface_get_material(0).next_pass =\
		#Global.packable_highlight_shader)
	#deselected.connect(func():
		#mesh_to_highlight.mesh.surface_get_material(0).next_pass = null)
		
	orig_pos_and_rot = {
		"position": collider.position,
		"rotation": collider.rotation
	}
	collider.set_collision_layer_value(2, true) # raycasting


func respawn() -> void:
	var prev_process_type = collider.process_mode
	collider.process_mode = Node.PROCESS_MODE_DISABLED
	
	collider.position = orig_pos_and_rot.position
	collider.rotation = orig_pos_and_rot.rotation
	collider.linear_velocity = Vector3(0,0,0)
	collider.angular_velocity = Vector3(0,0,0)
	
	collider.process_mode = prev_process_type


var _in_box: bool = false
var _in_fence: bool = false
func inside() -> bool: return not _in_fence && _in_box
