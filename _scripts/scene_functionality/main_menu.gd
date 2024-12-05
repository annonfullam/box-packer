extends Control
class_name MainMenu

@export var credit_node: Control


@onready var play: Button = $Buttons/Play
@onready var credits: Button = $Buttons/Credits
@onready var exit: Button = $Buttons/Exit


func _ready() -> void:
	play.connect("pressed", open_level_select)
	credits.connect("pressed", func(): if not credit_node.visible: credit_node.show() else: credit_node.hide())
	exit.connect("pressed", func(): get_tree().quit())


func open_level_select():
	Helpers.add_scene_to_parent(get_parent(), load("res://scenes/level_select.tscn"))
	hide()
