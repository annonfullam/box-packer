extends Node

#region Helper Functions
func cursor_raycast() -> Dictionary:
	var camera: Camera3D = get_viewport().get_camera_3d()
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var raycast_length: float = 1000
	
	var space_state: PhysicsDirectSpaceState3D = camera.get_world_3d().direct_space_state
	
	var ray: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	ray.collision_mask = 0b00000000_00000000_00000000_00000010
	ray.from = camera.project_ray_origin(mouse_pos)
	ray.to = ray.from + camera.project_ray_normal(mouse_pos) * raycast_length
	
	return space_state.intersect_ray(ray)


#endregion


#region Global References
var Input_Handler: InputHandler = null


#region Settings
var Snap_Position: bool = false
var Snap_Position_Step: float = 1

var Snap_Rotation: bool = false # Does not work atm
var Snap_Rotation_Step: float = 15.0

var Kinematic_Box: bool = true
#endregion

#endregion


#region Global Shader Stuff
var packable_highlight_shader: ShaderMaterial = preload("res://_resources/materials and shaders/packable_highlight_shader.tres")

var alpha_timer = 0
func _process(delta: float) -> void:
	alpha_timer = fmod(alpha_timer+delta*3, PI*2)
	packable_highlight_shader.set_shader_parameter("alphaAmt", 0.15+sin(alpha_timer)*0.05)
	
#endregion
