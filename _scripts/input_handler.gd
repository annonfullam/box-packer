extends Node
class_name InputHandler

@export var rotation_sens: float = 300
@export var position_sens: float = 600
@export var push_pull_sens: float = 500

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


#region Actions and Keybinding
func add_action(action_name: String, key: Key = KEY_NONE, deadzone: float = 0.0):
	InputMap.add_action(action_name, deadzone)
	
	if key != KEY_NONE:
		var input_event: InputEventKey = InputEventKey.new()
		input_event.keycode = key
	
		InputMap.action_add_event(action_name, input_event)
	
	print("Created ", action_name, " with keybind: ", str(key))


func remove_action(action_name: String):
	InputMap.erase_action(action_name)
	print("Removed action: ", action_name)


func change_action_keybind(action_name: String, new_key: Key):
	var input_event: InputEventKey = InputEventKey.new()
	input_event.keycode = new_key
	
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, input_event)
	
	print("Added ", str(new_key), " keybind to ", action_name)


func add_action_keybind(action_name: String, new_key: Key):
	var input_event: InputEventKey = InputEventKey.new()
	input_event.keycode = new_key
	
	InputMap.action_add_event(action_name, input_event)
	
	print("Added ", str(new_key), " keybind to ", action_name)


func remove_action_keybind(action_name: String, key: Key):
	var input_event: InputEventKey = InputEventKey.new()
	input_event.keycode = key
	
	InputMap.action_erase_event(action_name, input_event)
	
	print("Removed ", str(key), " keybind from ", action_name)

#endregion
