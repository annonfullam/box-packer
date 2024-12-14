extends Node

signal load_start
signal load_end

signal scene_change


var current_scene: Node = null
func _ready() -> void:
	current_scene = get_tree().current_scene
	get_tree().auto_accept_quit = false


func change_scene(path: String, default_path: bool = true) -> Node:
	load_start.emit()
	
	if default_path: path = "res://scenes/" + path + ".tscn"
	
	if OS.has_feature("editor"):
		if not FileAccess.file_exists(path):
			print("This scene does not exist in the file system")
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
	
	if OS.has_feature("editor"):
		if not FileAccess.file_exists(path):
			print("That file does not exist")
			return
	
	var new_scene: Node = load(path).instantiate()
	parent.add_child(new_scene)
	
	return new_scene


func quit():
	_notification(NOTIFICATION_WM_CLOSE_REQUEST)


signal saved
func _notification(what: int) -> void:
	match(what):
		NOTIFICATION_WM_CLOSE_REQUEST: # When the game closes
			export(GlobalReferences.PLAYER_DATA, "reta")
			current_scene.queue_free()
		NOTIFICATION_ENTER_TREE: # When the game starts
			import("reta")


func export(data: PlayerData, save_name: String):
	if OS.has_feature("editor"):
		print("You can't save stuff in the editor.")
		get_tree().quit()
		return

	var path: String = OS.get_executable_path().get_base_dir() + "/data/" + save_name + ".tres"
	var output:=ResourceSaver.save(data, path)
	print(output)
	
	await get_tree().create_timer(2).timeout
	get_tree().quit()


func import(save_name: String):
	if OS.has_feature("editor"):
		print("You can't import in the editor.")
		return
	
	var da: DirAccess = DirAccess.open(OS.get_executable_path().get_base_dir())
	da.make_dir("data")
	
	var path: String = OS.get_executable_path().get_base_dir() + "/data/" + save_name + ".tres"
	if not FileAccess.file_exists(path):
		print("that path doesn't exist!")
		return
	
	var data: PlayerData = ResourceLoader.load(path)
	GlobalReferences.PLAYER_DATA = data
