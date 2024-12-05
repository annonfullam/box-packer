extends Node


func cursor_raycast() -> Dictionary:
	var camera: Camera3D = get_viewport().get_camera_3d()
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var raycast_length: float = 1000
	
	var space_state: PhysicsDirectSpaceState3D = camera.get_world_3d().direct_space_state
	
	var ray: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	ray.collision_mask = 0b00000000_00000000_00000000_00000010 # this is the 'raycast' layer
	ray.from = camera.project_ray_origin(mouse_pos)
	ray.to = ray.from + camera.project_ray_normal(mouse_pos) * raycast_length
	
	return space_state.intersect_ray(ray)


# I did not write this code. Copy+paste ftw
func get_files_in_dir(path: String) -> Array:
	var files: Array = []
	var dir := DirAccess.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files


func add_scene_to_parent(parent: Node, child: PackedScene) -> Node:
	var new_child: Node = child.instantiate()
	parent.add_child(new_child)
	return new_child
