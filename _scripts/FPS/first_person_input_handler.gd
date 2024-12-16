extends InputHandler
class_name FirstPersonInputHandler

var jump_request: bool

var sprint_down: bool
var sprint_held: bool

var input_direction: Vector3

func _ready() -> void:
	GlobalReferences.INPUT = self


func _process(_delta: float) -> void:
	jump_request = Input.is_action_just_pressed("jump")
	
	#sprint_down = Input.is_action_just_pressed("sprint")
	sprint_held = Input.is_action_pressed("sprint")
	
	var input_dir_temp: Vector2 = Input.get_vector("fps_left", "fps_right", "fps_forward", "fps_back")
	input_direction = Vector3(input_dir_temp.x, 0, input_dir_temp.y)
