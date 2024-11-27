extends Node


func cursor_raycast() -> Dictionary:
	var camera: Camera3D = get_viewport().get_camera_3d()
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var raycast_length: float = 1000
	
	var space_state: PhysicsDirectSpaceState3D = camera.get_world_3d().direct_space_state
	var ray: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	ray.from = camera.project_ray_origin(mouse_pos)
	ray.to = ray.from + camera.project_ray_normal(mouse_pos) * raycast_length
	
	return space_state.intersect_ray(ray)

#@export var packable_highlight_shader: Material = preload("res://_resources/packable_highlight_shader.tres")
