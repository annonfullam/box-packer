extends Node3D
class_name Packables_Manager

var current_selection: Packable
var packables: Array[Packable] = []

@export var in_bounds: Area3D

@onready var game_manager: GameManager = $"../GameManager"


func _ready() -> void:
	for child in get_children():
		var packable_component: Packable = child.get_node("Packable")
		if not packable_component:
			return
	
		packables.append(packable_component)
		packable_component.register_in_scene(game_manager)
		packable_component.selected.connect(func(hit: Dictionary):
			current_selection = hit.collider.find_child("Packable"))
	in_bounds.body_exited.connect(func(node: Node3D):
		var child = node.find_child("Packable")
		if child: child.respawn())


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:	
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var hit: Dictionary = Global.cursor_raycast()
				if hit.has("collider"):
					var child = hit.collider.find_child("Packable")
					if child:
						child.selected.emit(hit)
						start_selection()
			elif current_selection:
				current_selection.deselected.emit()
				current_selection = null
				end_selection()


#region Interaction manager
func _physics_process(delta: float) -> void:
	if current_selection:
		control_selection(delta)

var selection_parent: RigidBody3D = null

@export var drop_spot_indicator: Node3D
@export var pitch_indicator: Node3D
@export var roll_indicator: Node3D
@export var yaw_indicator: Node3D

func start_selection():
	selection_parent = current_selection.get_parent() # Stores this for rotation manipulation so it doesn't have to fetch it every frame.
	
	drop_spot_indicator.show()


func end_selection():
	drop_spot_indicator.hide()
	
	pitch_indicator.hide()
	roll_indicator.hide()
	yaw_indicator.hide()


func control_selection(delta: float):
	if not selection_parent:
		return
	
	var input: InputHandler = Global.Input_Handler
	
	# Rotation 
	var rotation_amount = input.rotation_sens * delta
	selection_parent.angular_velocity.x = -input.pitch_axis * rotation_amount
	selection_parent.angular_velocity.y = input.yaw_axis * rotation_amount
	selection_parent.angular_velocity.z = -input.roll_axis * rotation_amount
	
	
	if input.pitch_axis != 0:
		pitch_indicator.global_position = selection_parent.global_position
		pitch_indicator.show()
	else:
		pitch_indicator.hide()
	
	if input.roll_axis != 0:
		roll_indicator.global_position = selection_parent.global_position
		roll_indicator.show()
	else:
		roll_indicator.hide()
	
	if input.yaw_axis != 0:
		yaw_indicator.global_position = selection_parent.global_position
		yaw_indicator.show()
	else:
		yaw_indicator.hide()
	
	
	# Position handler
	var plane_pos: Vector3 = plane_raycast(Vector3.FORWARD)
	selection_parent.linear_velocity = (plane_pos - selection_parent.position) * input.position_sens * delta
	
	# Push / Pull handler
	selection_parent.linear_velocity.z = input.push_pull_axis * -input.push_pull_sens * delta
	
	drop_spot_indicator.global_position = Vector3(selection_parent.global_position.x, drop_spot_indicator.global_position.y, selection_parent.global_position.z)


func plane_raycast(axis_up: Vector3) -> Vector3:
	var camera: Camera3D = get_viewport().get_camera_3d()
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var max_distance: float = 1000
	
	var plane: Plane = Plane(axis_up, selection_parent.global_position)
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * max_distance
	
	var result = plane.intersects_ray(from, to)
	return result if result else Vector3.ZERO # Returns a zero vector if the raycast misses
#endregion
