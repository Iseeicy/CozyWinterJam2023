extends CanvasLayer

signal cutscene_complete()
@export var dialog: PackedDialogGraph

@onready var _dialog_runner: DialogRunner = $DialogRunner
var _started: bool = false


func run():
	_dialog_runner.run_dialog(dialog)
	
func _input(event):
	if event.is_action_pressed("dialog_progress"):
		_dialog_runner.dialog_interact()


func _on_dialog_runner_transitioned(state, path):
	if path == "Active/Entry":
		_started = true
		return
	
	if _started and path == "Inactive":
		_started = false
		cutscene_complete.emit()
