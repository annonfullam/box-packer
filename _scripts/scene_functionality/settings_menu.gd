extends Control
class_name SettingsMenu


@onready var rotation_slider: HSlider = $VBoxContainer/RotationLabel/HSlider
@onready var rotation_value: SpinBox = $VBoxContainer/RotationLabel/SpinBox

@onready var position_slider: HSlider = $VBoxContainer/PositionLabel/HSlider
@onready var position_value: SpinBox = $VBoxContainer/PositionLabel/SpinBox


func _ready() -> void:
	rotation_slider.value = Settings.rotation_sens
	rotation_value.value = Settings.rotation_sens
	
	rotation_value.value_changed.connect(func(value: float):
		rotation_slider.value = value
		Settings.rotation_sens = value
		)
	
	rotation_slider.value_changed.connect(func(value: float):
		rotation_value.value = value
		Settings.rotation_sens = value
		)
	
	
	position_slider.value = Settings.position_sens
	position_value.value = Settings.position_sens
	
	position_value.value_changed.connect(func(value: float):
		position_slider.value = value
		Settings.position_sens = value
		)
	
	position_slider.value_changed.connect(func(value: float):
		position_value.value = value
		Settings.position_sens = value
		)
