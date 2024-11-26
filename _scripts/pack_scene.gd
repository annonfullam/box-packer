extends Node3D
class_name PackScene


func _ready() -> void:
	for child: Packable in $Packables.get_children():
		child.register_in_scene(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
