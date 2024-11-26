extends RayCast3D


@onready var camera: Camera3D = $".."

#
#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			#detect_clicked_object()


func _process(delta: float) -> void:
	if is_colliding():
		var collider = get_collider()
		print("Raycast hit: " + collider.name)
