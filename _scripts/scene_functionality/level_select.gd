extends Control
class_name LevelSelect

@onready var right_button: Button = $RightButton
@onready var left_button: Button = $LeftButton

@onready var level_tiles: Control = $LevelTiles


var current_level_selection: int = 1

func _ready() -> void:
	right_button.connect("pressed", func(): change_level_selection(1))
	left_button.connect("pressed", func(): change_level_selection(-1))
	
	$LevelButton.connect("pressed", go_to_level)
	$MainMenuButton.connect("pressed", func(): 
		hide()
		get_parent().get_node("MainMenuUI").show())
	
	populate_tiles()
	update_tiles()
	hide_edge_arrows()


func go_to_level():
	var level_data: Level = load("res://scenes/levels/" + str(current_level_selection) + ".tres")
	
	# Changes the scene
	var new_scene: Node = SceneManager.change_scene(level_data.background_scene_name)
	var game_manager: GameManager = new_scene.get_node("GameManager")
	
	game_manager.init_level(level_data)


func change_level_selection(amt: int):
	if Input.is_action_pressed("shift"):
		amt *= 5
	
	current_level_selection += amt
	current_level_selection = clamp(current_level_selection, 1, GlobalReferences.LEVEL_COUNT)
	
	update_tiles()
	hide_edge_arrows()


func hide_edge_arrows():
	if current_level_selection == 1:
		left_button.hide()
	else:
		left_button.show()
	
	if current_level_selection == GlobalReferences.LEVEL_COUNT:
		right_button.hide()
	else:
		right_button.show()


func update_tiles(): 
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(level_tiles, "position:x", -400 * (current_level_selection - 1), 0.2)


func populate_tiles():
	var tile_template: Label = level_tiles.get_child(0)
	
	for i in GlobalReferences.LEVEL_COUNT:
		var new_tile: Label = tile_template.duplicate()
		level_tiles.add_child(new_tile)
		new_tile.position.x = (400 * i) - 100
		new_tile.text = str(i + 1)
	
	tile_template.queue_free()
