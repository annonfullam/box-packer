extends Node

var control_camera: bool = true

@export var camera_controls: OrbitCamera


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and not event.is_echo():
			if event.keycode == KEY_H:
				camera_controls.process_mode = Node.PROCESS_MODE_DISABLED if control_camera else Node.PROCESS_MODE_ALWAYS
				control_camera = !control_camera
