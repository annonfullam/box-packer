extends Node3D

@export var background_scene: PackedScene

var level_to_export: Level

# TODO This will export a level resource after placing all of the objects
func _ready() -> void:
	add_child(background_scene.instantiate())
