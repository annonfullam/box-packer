extends Resource
class_name Level

 ## MUST BE UNIQUE. Just make it the same as the file name
@export var level_id: int

@export var box_size: Vector3 = Vector3.ONE
@export var box_position: Vector3 = Vector3.ZERO

## This is the environment, or world, the level is in.
@export var background_scene_name: String
@export var box_scene: PackedScene
@export var box_area: PackedScene
@export var fence_area: PackedScene

@export var packables: Array[PackableContainer]
 
var time: float = 0
var best_time: float


func populate_level(parent: Node3D):
	best_time = 0
	
	for p in packables:
		var node: Node3D = p.object_scene.instantiate()
		var packable_node: Packable = node.find_child("Packable")
		packable_node.start_pos_and_rot = {"position": p.start_position, "rotation": p.start_rotation}
		
		parent.add_child(node)
		node.global_position = p.start_position
		node.global_rotation = p.start_rotation


func create_box(parent: Node3D) -> Array[Area3D]:
	var _box_scene: Node3D = box_scene.instantiate()
	parent.owner.add_child(_box_scene)
	_box_scene.scale = box_size
	_box_scene.global_position = box_position
	
	var _box_area: Area3D = box_area.instantiate()
	parent.owner.add_child(_box_area)
	_box_area.global_scale(box_size + (Vector3.ONE * 0.05))
	_box_area.position = box_position
	
	var _fence_area: Area3D = fence_area.instantiate()
	parent.owner.add_child(_fence_area)
	_fence_area.global_scale(box_size + (Vector3.ONE * 0.15))
	_fence_area.position = box_position
	
	var result: Array[Area3D] = [_box_area, _fence_area]
	return result
