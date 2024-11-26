extends Node
class_name OrbitCamera

@export var target: Node3D
@export var orbit_distance: float = 5
@export var orbit_speed: float = 1
@export var sens: float = 0.1

@export_group("Box Walls")
@export var back: Node3D
@export var front: Node3D
@export var left: Node3D
@export var right: Node3D

var orbit_x: float
var orbit_y: float

@export var camera: Camera3D

func _ready() -> void:
	camera.global_transform.origin = target.global_transform.origin + Vector3(orbit_distance, 0, 0)
	camera.look_at(target.global_transform.origin)


var is_dragging: bool
func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = event.is_pressed()
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			orbit_distance -= sens * target.scale.x
			
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			orbit_distance += sens * target.scale.x
	
	
	if event is InputEventMouseMotion and is_dragging:
		orbit_x += event.relative.y * sens
		orbit_y += event.relative.x * sens


func _process(delta: float) -> void:
	orbit_x = clamp(orbit_x, -89, 89) # If angle goes to 90, the look_at() method will throw errors.
	orbit_distance = clamp(orbit_distance, target.scale.x + 2, target.scale.x * 4)
	
	var rad_x: float = deg_to_rad(orbit_x)
	var rad_y: float = deg_to_rad(orbit_y)
	
	var new_pos := Vector3(
		orbit_distance * cos(rad_x) * cos(rad_y),
		orbit_distance * sin(rad_x),
		orbit_distance * cos(rad_x) * sin(rad_y)
	)
	
	camera.global_transform.origin = target.global_transform.origin + new_pos
	camera.look_at(target.global_transform.origin)
	
	
	hide_relevant_box_walls()


func hide_relevant_box_walls():
	var direction: Vector3 = target.global_position - camera.global_position
	
	
	# FIXME: This is a TERRIBLE way to do this. So bad.
	if sign(direction.x) < 0: # if camera is on the right side of the box
		right.hide()
	else:
		right.show()
	
	if sign(direction.x) > 0:
		left.hide()
	else:
		left.show()
	
	if sign(direction.z) > 0: # if camera is in front of the box
		back.hide()
	else:
		back.show()
	
	if sign(direction.z) < 0:
		front.hide()
	else:
		front.show()
