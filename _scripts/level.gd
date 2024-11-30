extends Resource
class_name Level


@export var box_scene: PackedScene
@export var box_area: PackedScene
@export var fence_area: PackedScene

@export var packables: Array[PackableContainer]


func populate_level(parent: Node3D):	
	for p in packables:
		var node: Node3D = p.object_scene.instantiate()
		var packable_node: Packable = node.find_child("Packable")
		packable_node.start_pos_and_rot = {"position": p.start_position, "rotation": p.start_rotation}
		
		parent.add_child(node)
		node.global_position = p.start_position
		node.global_rotation = p.start_rotation


func create_box(parent: Node3D) -> Array[Area3D]:
	parent.owner.add_child(box_scene.instantiate())
	var _box_area: Area3D = box_area.instantiate()
	parent.owner.add_child(_box_area)
	var _fence_area: Area3D = fence_area.instantiate()
	
	parent.owner.add_child(_fence_area)
	
	var result: Array[Area3D] = [_box_area, _fence_area]
	return result
