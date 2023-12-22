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
	if get_tree().current_scene == self and visible:
		run_splash_sequence()

func _input(event):
	if event.is_action_pressed("pause"):
		finished.emit()

#
#	Virtual Functions
#

## Runs this splash sequence. Meant to be overridden. Does nothing by default.
func run_splash_sequence():
	finished.emit()
