extends Node3D
class_name Packable

signal selected
signal deselected

@onready var parent: RigidBody3D = $".."
@export var mesh_to_highlight: MeshInstance3D

func register_in_scene(manager: GameManager) -> void:
	manager.box_area.body_entered.connect(func(body: Node3D):
		if body != parent: return
		_in_box = true
		manager.check_all_in())
	manager.fence_area.body_exited.connect(func(body: Node3D):
		if body != parent: return
		_in_fence = false
		manager.check_all_in())
	manager.box_area.body_exited.connect(func(body: Node3D):
		if body != parent: return
		_in_box = false)
	manager.fence_area.body_entered.connect(func(body: Node3D):
		if body != parent: return
		_in_fence = true)
		
func _ready() -> void:
	assert(mesh_to_highlight.mesh.material != null, "there's a packable mesh without a material :(")
	# this might break when we add custom meshes
	selected.connect(func(_unused: Dictionary):
		mesh_to_highlight.mesh.material.next_pass =\
		Global.packable_highlight_shader)
	deselected.connect(func():
		mesh_to_highlight.mesh.material.next_pass = null)


var _in_box: bool = false
var _in_fence: bool = false
func inside() -> bool: return not _in_fence && _in_box
