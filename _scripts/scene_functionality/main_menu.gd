extends Control
class_name MainMenu

@export var credit_node: Control


@onready var play: Button = $Buttons/Play
@onready var credits: Button = $Buttons/Credits
@onready var exit: Button = $Buttons/Exit


func _ready() -> void:
	play.connect("pressed", play_button_pressed)
	credits.connect("pressed", func(): if not credit_node.visible: credit_node.show() else: credit_node.hide())
	exit.connect("pressed", func(): get_tree().quit())


func play_button_pressed():
	SceneManager.change_scene("level_select")
