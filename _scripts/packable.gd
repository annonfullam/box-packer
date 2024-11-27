extends Node3D
class_name Packable

var is_selected: bool = false

signal selected
signal deselected

@onready var rigidbody: RigidBody3D = $".."
@export var mesh_to_highlight: MeshInstance3D

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
		
func _ready() -> void:
	assert(mesh_to_highlight.mesh.material != null, "there's a packable mesh without a material :(")
	# this might break when we add custom meshes
	selected.connect(func(_unused):
		mesh_to_highlight.mesh.material.next_pass =\
		Global.packable_highlight_shader)
	deselected.connect(func(_unused):
		mesh_to_highlight.mesh.material.next_pass = null)


var _in_box: bool = false
var _in_fence: bool = false
func inside() -> bool: return !_in_fence && _in_box

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index==1:
		var hit: Dictionary = Global.cursor_raycast()
		if hit.has("collider"):
			selected.emit(hit)
