@tool
extends Node3D

const scene_mappings: Dictionary = {
	"Factory":"factory_scene"
}
const scene_names: String = "Factory,"

var level_to_export: Level

# TODO This will export a level resource after placing all of the objects
@export_range(0, 0, 1, "or_greater") var level_id: int

@export_custom(PROPERTY_HINT_ENUM, scene_names, PROPERTY_USAGE_EDITOR) var background_scene_name: String = "Factory"

@export var box_model: PackedScene = load("res://prefabs/box.tscn")
# TODO: combine these two (and maybe the one above)? if one is changed the other is 99% going to be change
@export var box_area: PackedScene = load("res://prefabs/box_area.tscn")
@export var box_fence: PackedScene = load("res://prefabs/fence_area.tscn")

@onready var background_holder_node = $BackgroundHolder
var null_resource = load("res://_resources/null_scene.tscn")

signal background_signal
signal box_model_signal
signal box_area_signal
signal box_fence_signal
var prev_vals: Dictionary = {
	"background_scene_name": background_scene_name,
	"box_model": box_model,
	"box_area": box_area,
	"box_fence": box_fence
}
func _process(delta):
	if Engine.is_editor_hint():
		# setting up signals
		if prev_vals.background_scene_name != background_scene_name:
			background_signal.emit(prev_vals.background_scene_name)
			prev_vals.background_scene_name = background_scene_name
		if prev_vals.box_model != box_model:
			box_model_signal.emit(prev_vals.box_model)
			prev_vals.box_model = box_model
		if prev_vals.box_area != box_area:
			box_area_signal.emit(prev_vals.box_area)
			prev_vals.box_area = box_area
		if prev_vals.box_fence != box_fence:
			box_fence_signal.emit(prev_vals.box_fence)
			prev_vals.box_fence = box_fence

func _ready() -> void:
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
	
	# changes background when user changes it in menu
	background_signal.connect(func(prev_name):
		background_holder_node.find_child(prev_name).visible=false
		background_holder_node.find_child(background_scene_name).visible=true
		pass)
	# changes box model when user changes it
	box_model_signal.connect(func(_arg):
		var to_remove = self.find_child("BoxModel")
		to_remove.name = "removing"
		
		var model = box_model if box_model else null_resource
		var to_add = model.instantiate()
		to_add.name = "BoxModel"
		self.add_child(to_add)
		to_add.owner = self
		for child in to_remove.get_children():
			child.reparent(to_add)
		self.remove_child(to_remove)
		pass)
	# changes box area when user changes it
	box_area_signal.connect(func(_arg):
		var box = self.find_child("BoxModel")
		var to_remove = box.find_child("BoxArea")
		if to_remove: box.remove_child(to_remove)
		
		var model = box_area if box_area else null_resource
		var to_add = model.instantiate()
		to_add.name = "BoxArea"
		to_add.set_meta("_edit_lock_", true)
		box.add_child(to_add)
		to_add.owner = self
		pass)
	# changes box fence when user changes it
	box_fence_signal.connect(func(_arg):
		var box = self.find_child("BoxModel")
		var to_remove = box.find_child("BoxFence")
		if to_remove: box.remove_child(to_remove)
		
		var model = box_fence if box_fence else null_resource
		var to_add = model.instantiate()
		to_add.name = "BoxFence"
		to_add.set_meta("_edit_lock_", true)
		box.add_child(to_add)
		to_add.owner = self
		pass)
		
func export():
	var to_return = '[gd_resource type="Resource" script_class="Level" format=3 uid="$SET_UID"]'
	
	to_return = Array(to_return.split("$SET_UID")).map(
		func(v): v+ResourceUID.create_id()).reduce(
		func(a,str): a+str, "")
	return to_return
		
