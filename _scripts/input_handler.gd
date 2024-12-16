extends Node
class_name InputHandler


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
