extends Node3D
class_name Packables_Manager

var current_selection: Packable
var packables: Array[Packable] = []
@export var in_bounds: Area3D

@onready var game_manager: GameManager = $"../GameManager"

func _ready() -> void:
	curr_mouse_pos = get_viewport().get_mouse_position()
	
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

var prev_mouse_pos: Vector2
var curr_mouse_pos: Vector2
func _input(event: InputEvent) -> void:
	# Selection Code
	if event is InputEventMouseButton:	
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var hit: Dictionary = Global.cursor_raycast()
				if hit.has("collider"):
					var child = hit.collider.find_child("Packable")
					if child:
						child.selected.emit(hit)
						selection_parent = current_selection.get_parent() # Stores this for rotation manipulation so it doesn't have to fetch it every frame.
			elif current_selection:
				current_selection.deselected.emit()
				current_selection=null

	
	
	if event is InputEventMouseMotion:
		curr_mouse_pos = event.position
		var dir: Vector2 = curr_mouse_pos - prev_mouse_pos
		
		prev_mouse_pos = curr_mouse_pos
		


func _physics_process(delta: float) -> void:
	if current_selection:
		control_selection(delta)

var selection_parent: RigidBody3D = null
@export var rotation_sens: float = 300
@export var push_pull_sens: float = 500
func control_selection(delta: float):
	if not selection_parent:
		return
	
	var input: InputHandler = Global.Input_Handler
	
	# Rotation 
	var rotation_amount = rotation_sens*delta
	selection_parent.angular_velocity.x = -input.pitch_axis * rotation_amount
	selection_parent.angular_velocity.y = input.yaw_axis * rotation_amount
	selection_parent.angular_velocity.z = input.roll_axis * rotation_amount
	
	
	# Position handler
	var plane_pos: Vector3 = plane_raycast(Vector3.FORWARD)
	selection_parent.linear_velocity = (plane_pos-selection_parent.position)*10
	
	selection_parent.constant_force.z = input.push_pull_axis * -push_pull_sens

func plane_raycast(axis_up: Vector3) -> Vector3:
	var camera: Camera3D = get_viewport().get_camera_3d()
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var max_distance: float = 1000
	
	var plane: Plane = Plane(axis_up, selection_parent.global_position)
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * max_distance
	
	var result = plane.intersects_ray(from, to)
	return result if result else Vector3.ZERO # Returns a zero vector if the raycast misses
