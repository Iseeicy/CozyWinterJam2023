extends Control

@export var dialog_graph: PackedDialogGraph

@onready var _dialog_runner: DialogRunner = $DialogRunner
@onready var _slider: Slider = $MainMargin/VBoxContainer/ProgressSlider
var _slides: Array[Control] = []
var _max_slide_count: float = 0
var _current_slide: Control = null

func _ready():
	for child in $Slides.get_children():
		_slides.push_back(child)
	_max_slide_count = _slides.size()

	_dialog_runner.run_dialog(dialog_graph)

func _input(event):
	if (event.is_action("shoot_hook_a") or event.is_action("shoot_hook_b")) and event.is_pressed():
		_dialog_runner.dialog_interact()




func _on_dialog_runner_transitioned(state, _path):
	if _slider:_slider.visible = state.name == "DialogText"
	if _current_slide:
		_current_slide.queue_free()
		_current_slide = null
	if not state.name == "DialogText": return
	if _slides.size() == 0: return

	_current_slide = _slides.pop_front()
	_current_slide.reparent($MainMargin/VBoxContainer/SlideParent)
	_slider.value = lerpf(100, 0, _slides.size() / _max_slide_count)
	
