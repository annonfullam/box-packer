@tool
extends Node3D

@export_range(1, 1, 1, "or_greater") var level_id: int = 1
@export_enum("none","factory_scene") var background_scene_name: String = "none"
@export var btn_refresh_background: bool:
	set(value): refresh_background(background_scene_name)

@export_subgroup("Box Scenes", "box_")
@export var box_model: PackedScene
# TODO: combine these two (and maybe the one above)? if one is changed the other is 99% going to be change
@export var box_area: PackedScene
@export var box_fence: PackedScene

@export_category("Action Buttons")
@export var can_export: bool
@export var overwrite: bool
@export var btn_import: bool:
	set(value): import()
@export var btn_export: bool:
	set(value): export()
@export_subgroup("Danger Zone | Can't Undo")
@export var btn_refresh_box: bool:
	set(value): refresh_box(Vector3.ZERO, Vector3.ZERO, Vector3.ONE)
@export var btn_clear_packables: bool:
	set(value): clear_packables()
@export var btn_danger_reset_editor: bool:
	set(value):
		level_id = 1
		can_export = false
		overwrite = false
		background_scene_name = "none"
		refresh_background(background_scene_name)
		refresh_box(Vector3.ZERO, Vector3.ZERO, Vector3.ONE)
		clear_packables()
@export var btn_success_start_new_level: bool:
	set(value):
		if background_scene_name == "none":
			set_response_text("Please set a background scene name.")
		
		if not box_model or not box_area or not box_fence:
			set_response_text("You haven't set either a box model, or area, or fence.")
			return
		
		set_level_id()
		refresh_box(Vector3.ZERO, Vector3.ZERO, Vector3.ONE)
		clear_packables()
@export var btn_info_open_space_at_id: bool:
	set(value):
		var path: String = "res://scenes/levels/"
		var dir: DirAccess = DirAccess.open(path)
		
		if not dir.file_exists(path + str(level_id) +".tres"):
			set_response_text("You can't open a spot that's already open...")
			return
		
		var filenames: PackedStringArray = dir.get_files()
		filenames.reverse()
		for filename: String in filenames:
			if int(filename.replace(".tres", "")) < level_id: continue
			else:
				var new_name: String = str(int(filename.replace(".tres", "")) + 1) + ".tres"
				dir.rename(filename, new_name)
@export var btn_danger_collapse_space_at_id: bool:
	set(value):
		var path: String = "res://scenes/levels/"
		var dir: DirAccess = DirAccess.open(path)
		
		if dir.file_exists(path + str(level_id) + ".tres"):
			set_response_text("Cannot collapse when there is a file at that level id.")
			return
		
		if not dir.file_exists(path + str(level_id + 1) + ".tres"):
			set_response_text("Theres nothing to collapse.")
			return
		
		var filenames: PackedStringArray = dir.get_files()
		for filename: String in filenames:
			if int(filename.replace(".tres", "")) < level_id: continue
			else:
				var new_name: String = str(int(filename.replace(".tres", "")) - 1) + ".tres"
				dir.rename(filename, new_name)



func set_level_id():
	# sets id to first available id
	var files = DirAccess.open("res://scenes/levels/").get_files()
	var level_ids = []
	for file in files:
		level_ids.push_back(int(file.split(".")[0]))
	level_ids.sort()
	var index=1
	for id in level_ids:
		if id != index:
			break
		index+=1
	level_id = index


func refresh_box(position: Vector3, rotation: Vector3, scale: Vector3):
	var box: Node3D = self.find_child("BoxModel", false)
	if box: 
		box.name = "removing"
		box.queue_free()
	
	var new_box: Node3D = box_model.instantiate()
	self.add_child(new_box)
	new_box.owner = self
	new_box.name = "BoxModel"
	
	
	var nbox_area: Node3D = box_area.instantiate()
	new_box.add_child(nbox_area)
	nbox_area.owner = self
	nbox_area.set_meta("_edit_lock_", true)
	
	var nfence_area: Node3D = box_fence.instantiate()
	new_box.add_child(nfence_area)
	nfence_area.owner = self
	nfence_area.set_meta("_edit_lock_", true)
	
	
	new_box.global_position = position
	new_box.global_rotation = rotation
	new_box.scale = scale


func clear_packables():
	for child in self.get_node("Packables").get_children():
		child.name = "_"
		child.queue_free()


func export():
	if not can_export:
		set_response_text("You have not enabled exporting!")
		return
	
	if background_scene_name == "none":
		set_response_text("You must select a background before exporting!")
		return
	
	if not overwrite and FileAccess.file_exists("res://scenes/levels/" + str(level_id) + ".tres"):
		set_response_text("There is already a level at this location!")
		await get_tree().create_timer(2.1).timeout
		set_response_text("If you want to overwrite enable overwriting.")
		return
	
	can_export = false
	overwrite = false
	
	var export_level: Level = Level.new()
	export_level.level_id = level_id
	
	export_level.background_scene_name = background_scene_name
	export_level.box_scene = box_model
	export_level.box_area = box_area
	export_level.fence_area = box_fence
	
	var box_node: Node3D = get_node("BoxModel")
	export_level.box_position = box_node.global_position
	export_level.box_rotation = box_node.global_rotation
	export_level.box_size = box_node.scale
	
	
	var packables_container: Node = get_node("Packables")
	for child: Node in packables_container.get_children():
		var new_packable: PackableContainer = PackableContainer.new()
		var packed_scene: PackedScene = PackedScene.new()
		packed_scene.pack(child)
		
		new_packable.object_scene = packed_scene
		new_packable.start_position = child.global_position
		new_packable.start_rotation = child.global_rotation
		
		export_level.packables.append(new_packable)
	
	var check_error: Error = ResourceSaver.save(export_level, "res://scenes/levels/" + str(export_level.level_id) + ".tres")
	if check_error: 
		set_response_text("Something went wrong!")
	else:
		set_response_text("Successfully exported level!")


func import():
	# Gets level count based on files in levels folder
	var level_count: int = 0
	var dir := DirAccess.open("res://scenes/levels/")
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			level_count += 1
	dir.list_dir_end()
	
	if level_id > level_count:
		set_response_text("There is no level with id: " + str(level_id) + ". Maybe you want to export?")
		return
	
	var level: Level = ResourceLoader.load("res://scenes/levels/" + str(level_id) + ".tres")
	
	box_model = level.box_scene
	box_area = level.box_area
	box_fence = level.fence_area
	refresh_box(level.box_position, level.box_rotation, level.box_size)
	
	background_scene_name = level.background_scene_name
	refresh_background(level.background_scene_name)
	
	clear_packables()
	
	var i: int = 0
	for child: PackableContainer in level.packables:
		var npackable: Node3D = child.object_scene.instantiate()
		add_child(npackable)
		npackable.owner = self
		npackable.name = "Packable" + str(i) if i > 0 else "Packable"
		npackable.reparent($Packables, true)
		
		npackable.global_position = child.start_position
		npackable.global_rotation = child.start_rotation
		
		i += 1


func refresh_background(background_name: String):
	var container: Node = $BackgroundContainer
	var old_background: Node3D = container.get_child(0)
	if old_background: old_background.queue_free()
	
	if background_name == "none": return
	
	var path: String = "res://scenes/" + background_name + ".tscn"
	
	# Abort if file doesn't exist
	if not FileAccess.file_exists(path):
		set_response_text("File doesn't exist. Is the background scene name correct?")
		return
	
	# Add new background
	var new_background: Node3D = load(path).instantiate()
	add_child(new_background)
	new_background.owner = self
	
	new_background.reparent(container, true)

const text_visible_duration: float = 2
func set_response_text(text: String):
	$ResponseLabel.text = text
	await get_tree().create_timer(text_visible_duration).timeout
	$ResponseLabel.text = ""
