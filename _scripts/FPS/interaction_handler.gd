extends Area3D
class_name InteractionHandler

var _current_selection: Area3D = null

func _ready() -> void:
	area_entered.connect(_on_enter)
	area_exited.connect(_on_exit)


func _on_enter(area: Area3D):
	if _current_selection == null:
		_current_selection = area


func _on_exit(area: Area3D):
	if area == _current_selection:
		_current_selection = null


func _process(delta: float) -> void:
	if not _current_selection:
		return
	
	if Input.is_action_just_pressed("fps_interact"):
		_current_selection.get_parent().queue_free()
		_current_selection = null
