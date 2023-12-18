extends Control

#
#	Exports
#

signal pause_changed(is_paused: bool)

#
#	Private Variables
#

var _is_paused: bool = false

#
#	Godot Functions
#

func _ready():
	set_paused(false)

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		set_paused(not _is_paused)
		get_viewport().set_input_as_handled()
#
#	Public Functions
#

func set_paused(is_paused: bool) -> void:
	_is_paused = is_paused
	visible = is_paused
	pause_changed.emit()

#
#	Signals
#

func _on_resume_button_pressed():
	set_paused(false)

func _on_quit_button_pressed():
	$QuitConfirmationDialog.show()

func _on_quit_confirmation_dialog_confirmed():
	get_tree().quit()
