extends Control

@export var dialog_graph: PackedDialogGraph

@onready var _dialog_runner: DialogRunner = $DialogRunner
var _slides: Array[Control] = []

func _ready():
	for child in $Slides.get_children():
		_slides.push_back(child)

	_dialog_runner.run_dialog(dialog_graph)

func _input(event):
	if (event.is_action("shoot_hook_a") or event.is_action("shoot_hook_b")) and event.is_pressed():
		_dialog_runner.dialog_interact()


