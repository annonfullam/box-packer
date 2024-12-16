extends InputHandler
class_name PackingInputHandler

var roll_axis: float
var pitch_axis: float
var yaw_axis: float

var alt_axis_mode: bool

func _ready() -> void:
	GlobalReferences.INPUT = self


func _process(_delta: float) -> void:
	roll_axis = Input.get_axis("rotate_roll_negative", "rotate_roll_positive")
	pitch_axis = Input.get_axis("rotate_pitch_negative", "rotate_pitch_positive")
	yaw_axis = Input.get_axis("rotate_yaw_negative", "rotate_yaw_positive")
	
	alt_axis_mode = Input.is_action_pressed("alt_axis_mode")
