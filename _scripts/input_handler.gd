extends Node
class_name InputHandler

var roll_axis: float
var pitch_axis: float
var yaw_axis: float

func _process(delta: float) -> void:
	
	roll_axis = Input.get_axis("rotate_roll_negative", "rotate_roll_positive")
	pitch_axis = Input.get_axis("rotate_pitch_negative", "rotate_pitch_positive")
	yaw_axis = Input.get_axis("rotate_yaw_negative", "rotate_yaw_positive")
	


func _input(event: InputEvent) -> void:
	pass
	# This method will handle all of the non-axes inputs
	# EX: Jump, etc.


#region Actions and Keybinding
func add_action(name: String, key: Key = KEY_NONE, deadzone: float = 0.0):
	InputMap.add_action(name, deadzone)
	
	if key != KEY_NONE:
		var input_event: InputEventKey = InputEventKey.new()
		input_event.keycode = key
	
		InputMap.action_add_event(name, input_event)
	
	print("Created ", name, " with keybind: ", str(key))


func remove_action(name: String):
	InputMap.erase_action(name)
	print("Removed action: ", name)


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
