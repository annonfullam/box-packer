extends Node

signal load_start
signal load_end

signal scene_change


var current_scene: Node = null
func _ready() -> void:
	current_scene = get_tree().current_scene


func change_scene(path: String, default_path: bool = true) -> Node:
	load_start.emit()
	
	if default_path: path = "res://scenes/" + path + ".tscn"
	
	if not FileAccess.file_exists(path):
		print("Screw you, this scene does not exist in the file system")
		return
	
	var new_scene: Node = load(path).instantiate()
	get_tree().root.add_child(new_scene)
	
	load_end.emit()
	
	current_scene.queue_free()
	current_scene = new_scene
	
	scene_change.emit()
	return current_scene


func add_scene(path: String, parent: Node, default_path: bool = true) -> Node:
	if default_path: path = "res://scenes/" + path + ".tscn"
	
	if not FileAccess.file_exists(path):
		print("That file does not exist")
		return
	
	var new_scene: Node = load(path).instantiate()
	parent.add_child(new_scene)
	
	return new_scene
