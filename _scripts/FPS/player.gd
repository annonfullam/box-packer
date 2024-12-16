extends CharacterBody3D


@export var speed: float = 7
@export var jump_velocity: float = 10
@export var mouse_sens_x: float = 0.1
@export var mouse_sens_y: float = 0.1

@onready var input: FPSInputHandler = $InputHandler
@onready var camera: Camera3D = $Camera3D


var desired_rotation_y: float

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_delta: Vector2 = event.relative
		var y_rotation: float = deg_to_rad(-mouse_delta.x * mouse_sens_x)
		var x_rotation: float = deg_to_rad(-mouse_delta.y * mouse_sens_y)
		rotate_y(y_rotation)
		camera.rotate_x(x_rotation)
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -80, 90)
		
	elif event is InputEventKey and not event.is_echo() and event.is_pressed():
		if event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if not Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if input.jump_request and is_on_floor():
		velocity.y = jump_velocity

	var direction: Vector3 = (transform.basis * input.input_direction).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
