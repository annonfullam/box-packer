extends Node
class_name FirstPersonController

@export var camera: Camera3D

@export var speed: float
@export var sprint_speed_multiplier: float = 1.5
@export var jump_velocity: float
@export var gravity: float
@export var mouse_sens_x: float = 0.1
@export var mouse_sens_y: float = 0.1

@onready var input: FirstPersonInputHandler = $InputHandler
@onready var player: CharacterBody3D = $".."

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_delta: Vector2 = event.relative
		var y_rotation: float = deg_to_rad(-mouse_delta.x * mouse_sens_x)
		var x_rotation: float = deg_to_rad(-mouse_delta.y * mouse_sens_y)
		player.rotate_y(y_rotation)
		camera.rotate_x(x_rotation)
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -80, 90)
		
	elif event is InputEventKey and not event.is_echo() and event.is_pressed():
		if event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if not Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_CAPTURED


func _process(delta: float) -> void:
	var _on_floor: bool = player.is_on_floor()
	if not _on_floor:
		player.velocity.y -= gravity * delta
	
	if input.jump_request and _on_floor:
		player.velocity.y = jump_velocity

	var direction: Vector3 = (player.transform.basis * input.input_direction).normalized()
	if direction:
		var _current_speed: float = speed if not input.sprint_held else speed * sprint_speed_multiplier # Sprinting handler
		player.velocity.x = direction.x * _current_speed
		player.velocity.z = direction.z * _current_speed
	else:
		player.velocity.x = 0
		player.velocity.z = 0

	player.move_and_slide()
