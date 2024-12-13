extends Control
class_name MainMenu

@export var credit_node: Control
@export var settings_menu: Control

@onready var play: Button = $Buttons/Play
@onready var settings: Button = $Buttons/Settings
@onready var credits: Button = $Buttons/Credits
@onready var exit: Button = $Buttons/Exit


func _ready() -> void:
	get_tree().paused = false
	
	play.connect("pressed", open_level_select)
	credits.connect("pressed", func(): if not credit_node.visible: credit_node.show() else: credit_node.hide())
	settings.connect("pressed", func():
		var new_scene: Node = SceneManager.add_scene("settings_menu", get_parent())
		new_scene.get_node("BackButton").connect("pressed", func():
			new_scene.queue_free()
			show())
		hide())
	exit.connect("pressed", func(): get_tree().quit())


func open_level_select():
	SceneManager.add_scene("level_select", get_parent())
	hide()
