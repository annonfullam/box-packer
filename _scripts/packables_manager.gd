extends Node3D
class_name PackablesManager

var current_selection: Packable
var packables: Array[Packable] = []

@export var in_bounds: Area3D
var box_area: Area3D
var fence_area: Area3D

#@onready var game_manager: GameManager = $"../GameManager"

# Called by the level script
func initialize_packables():
	for child in get_children():
		var packable_component: Packable = child.get_node("Packable")
		if not packable_component:
			print("Something went wrong... There is a child to the packables_manager that is not a Packable!!!")
			return
		
		packables.append(packable_component)
		packable_component.initialize(self)
		
		packable_component.selected.connect(func(hit: Dictionary): current_selection = hit.collider.get_node("Packable"))

# Called by the level script
func initialize_bounds():
	in_bounds.body_exited.connect(func(node: Node3D):
		var child = node.get_node("Packable")
		if child: 
			child.respawn()
			if child == current_selection: end_selection())


func check_all_packed():
	if current_selection != null: return
	
	for child: Packable in packables:
		if not child.is_inside(): return
	
	GlobalReferences.LEVEL.ended.emit()


#region Interaction manager
var can_select: bool= true

func _physics_process(delta: float) -> void:
	if can_select:
		control_selection(delta)


func _input(event: InputEvent) -> void:
	if can_select and event is InputEventMouseButton:	
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var hit: Dictionary = Helpers.cursor_raycast()
				if hit.has("collider"):
					var child = hit.collider.find_child("Packable")
					if child:
						child.selected.emit(hit)
						start_selection()
			elif current_selection:
				current_selection.deselected.emit()
				end_selection()



func start_selection():
	selection_parent = current_selection.get_parent() # Stores this for rotation manipulation so it doesn't have to fetch it every frame.
	
	drop_spot_indicator.show()
	
	# Start the level when the first object is selected
	if not GlobalReferences.LEVEL.has_started: GlobalReferences.LEVEL.started.emit()


func end_selection():
	selection_parent.gravity_scale = 1
	
	current_selection = null
	drop_spot_indicator.hide()
	
	pitch_indicator.hide()
	roll_indicator.hide()
	yaw_indicator.hide()
	
	check_all_packed()


var selection_parent: RigidBody3D = null
var input: InputHandler

func control_selection(delta: float):
	if not current_selection or not selection_parent: # If there is no selection, just ignore all of this code.
		return
	
	input = GlobalReferences.INPUT
	handle_indicators()

	if Settings.snap_rotation: control_snap_rotation(delta)
	else: control_rotation(delta)
	

	var desired_position: Vector3 = plane_raycast(Vector3.FORWARD) if not input.alt_axis_mode else plane_raycast(Vector3.UP)
	if Settings.snap_position: desired_position = round(desired_position * Settings.snap_position_step) / Settings.snap_position_step # Snap position to grid
	
	selection_parent.gravity_scale = 0 if input.alt_axis_mode else 1 # The object will slowly fall if gravity isn't disabled without changing the y position
	selection_parent.linear_velocity = (desired_position - selection_parent.position) * input.position_sens * delta # Apply velocity to move to the right position
	clamp_velocity()


func control_rotation(delta: float):
	var rotation_amount: float = input.rotation_sens * delta
	selection_parent.angular_velocity.x = -input.pitch_axis * rotation_amount
	selection_parent.angular_velocity.y = input.yaw_axis * rotation_amount
	selection_parent.angular_velocity.z = -input.roll_axis * rotation_amount


var rotate_request: bool = false
var rotation_timer: float = 0.0
var desired_rotation: Vector3
func control_snap_rotation(delta: float):
	var input_vector: Vector3 = Vector3(-input.pitch_axis, input.yaw_axis, -input.roll_axis)
	
	if not rotate_request:
		if input_vector.length() != 0:
			rotate_request = true
			if desired_rotation == Vector3.INF: # If desired_rotation hasn't been already set
				desired_rotation = selection_parent.rotation + input_vector * deg_to_rad(Settings.snap_rotation_step)
				desired_rotation = round(desired_rotation * 100) / 100
	else:
		
		# FIXME: This john really freaks out after going ouit of -180 or 180 degrees
		selection_parent.angular_velocity = (desired_rotation - selection_parent.rotation) * input.rotation_sens * 5 * delta
		
		# If the object has reached it's target
		if desired_rotation == round(selection_parent.rotation * 100) / 100:
			desired_rotation = Vector3.INF
			rotate_request = false


@export var drop_spot_indicator: Node3D
@export var pitch_indicator: Node3D
@export var roll_indicator: Node3D
@export var yaw_indicator: Node3D
func handle_indicators():
	drop_spot_indicator.global_position = Vector3(selection_parent.global_position.x, drop_spot_indicator.global_position.y, selection_parent.global_position.z)
	
	pitch_indicator.hide()
	roll_indicator.hide()
	yaw_indicator.hide()
	
	if input.pitch_axis != 0:
		pitch_indicator.global_position = selection_parent.global_position
		pitch_indicator.show()
		
	if input.roll_axis != 0:
		roll_indicator.global_position = selection_parent.global_position
		roll_indicator.show()
		
	if input.yaw_axis != 0:
		yaw_indicator.global_position = selection_parent.global_position
		yaw_indicator.show()

@export var max_velocity: float = 50
func clamp_velocity():
	selection_parent.linear_velocity.x = clamp(selection_parent.linear_velocity.x, -max_velocity, max_velocity)
	selection_parent.linear_velocity.y = clamp(selection_parent.linear_velocity.y, -max_velocity, max_velocity)
	selection_parent.linear_velocity.z = clamp(selection_parent.linear_velocity.z, -max_velocity, max_velocity)


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
