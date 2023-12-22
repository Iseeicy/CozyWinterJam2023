extends CanvasLayer
class_name SplashScreen

#
#	Exports
#

## Called when the splash screen has finished displaying
signal finished()

#
#	Godot Functions
#

func _ready():
	visibility_changed.connect(_run_splash_sequence.bind())

	if get_tree().current_scene == self and visible:
		_run_splash_sequence()

#
#	Virtual Functions
#

## Runs this splash sequence. Meant to be overridden. Does nothing by default.
func _run_splash_sequence():
	finished.emit()

#
#	Signals
#

func _on_visibility_changed():
	if visible: _run_splash_sequence()