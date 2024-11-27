extends Node


func get_global_mouse_position() -> Vector3:
	var camera: Camera3D = get_viewport().get_camera_3d()
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	
	var space_state: PhysicsDirectSpaceState3D = camera.get_world_3d().direct_space_state
	var ray: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	ray.from = camera.project_ray_origin(mouse_pos)
	ray.to = ray.from + camera.project_ray_normal(mouse_pos) * 1000
		
	var result: Dictionary = space_state.intersect_ray(ray)
	var object_node: Node3D = result["collider"]
	return object_node.position
