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
