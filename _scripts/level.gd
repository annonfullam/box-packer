extends Resource
class_name Level

 ## MUST BE UNIQUE. Just make it the same as the file name
@export var level_id: int

@export var box_size: Vector3 = Vector3.ONE
@export var box_position: Vector3 = Vector3.ZERO
@export var box_rotation: Vector3 = Vector3.ZERO

## This is the environment, or world, the level is in.
@export var background_scene_name: String
@export var box_scene: PackedScene
@export var box_area: PackedScene
@export var fence_area: PackedScene

@export var packables: Array[PackableContainer]
 
var count_time: bool = false
var time: float = 0
# TODO: Best time will not persist through sessions of the game
var best_time: float = -1

var has_started: bool = false
signal initialized
signal started
signal ended


func _init() -> void:
	started.connect(func():
		count_time = true
		has_started = true)
	ended.connect(func():
		count_time = false
		if time < best_time or best_time == -1: best_time = time)


# Called by game manager
func initialize(pm: PackablesManager):
	time = 0
	has_started = false
	
	create_box(pm)
	create_packables(pm)
	
	pm.initialize_packables()
	pm.initialize_bounds()
	
	GlobalReferences.LEVEL = self
	initialized.emit()


# Must be called by the game manager in _process
func update(delta: float):
	if count_time: time += delta


func create_packables(parent: Node3D):
	for p in packables:
		var node: Node3D = p.object_scene.instantiate()
		var packable_node: Packable = node.find_child("Packable")
		packable_node.start_pos_and_rot = {"position": p.start_position, "rotation": p.start_rotation}
		
		parent.add_child(node)
		node.global_position = p.start_position
		node.global_rotation = p.start_rotation


func create_box(parent: PackablesManager):
	var _box_scene: Node3D = box_scene.instantiate()
	parent.owner.add_child(_box_scene)
	_box_scene.scale = box_size
	
	var _box_area: Area3D = box_area.instantiate()
	parent.owner.add_child(_box_area)
	_box_area.global_scale(box_size + (Vector3.ONE * 0.05))
	_box_area.position = box_position
	
	var _fence_area: Area3D = fence_area.instantiate()
	parent.owner.add_child(_fence_area)
	_fence_area.global_scale(box_size + (Vector3.ONE * 0.15))
	_fence_area.position = box_position
	
	_box_scene.global_position = box_position
	_box_scene.global_rotation = box_rotation
	
	# Assign areas to packables manager
	parent.box_area = _box_area
	parent.fence_area = _fence_area
