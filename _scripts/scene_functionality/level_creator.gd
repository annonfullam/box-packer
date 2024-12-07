@tool
extends Node3D

@export_range(0, 0, 1, "or_greater") var level_id: int = -1
@export_enum("factory_scene",) var background_scene_name: String

@export var box_model: PackedScene
# TODO: combine these two (and maybe the one above)? if one is changed the other is 99% going to be change
@export var box_area: PackedScene
@export var fence_area: PackedScene

var null_resource = load("res://_resources/null_scene.tscn")


@export var btn_info_export: bool:
	set(value): export()

## Be careful pressing this because this will clear the box model's position!
@export var btn_reset_box: bool:
	set(value): 
		refresh_box()
		set_level_id()

## THERE IS NO WAY TO UNDO THIS
@export var btn_clear_packables: bool:
	set(value):
		for child in self.get_node("Packables").get_children():
			child.name = "sus"
			child.queue_free()

var level_to_export: Level

func refresh_box():
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
	
	var nfence_area: Node3D = fence_area.instantiate()
	new_box.add_child(nfence_area)
	nfence_area.owner = self
	nfence_area.set_meta("_edit_lock_", true)


func export():	
	var export_level: Level = Level.new()
	export_level.level_id = level_id
	export_level.background_scene_name = background_scene_name
	export_level.box_scene = box_model
	export_level.box_area = box_area
	export_level.fence_area = fence_area
	
	var box_node: Node3D = get_node("BoxModel")
	export_level.box_position = box_node.global_position
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
	
	ResourceSaver.save(export_level, "res://scenes/levels/" + str(export_level.level_id) + ".tres")


# TODO: Load resource from levels file
func import():
	pass


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
