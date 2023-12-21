extends CanvasLayer

@export var dialog: PackedDialogGraph

func _ready():
	$DialogRunner.run_dialog(dialog)
	
func _input(event):
	if event.is_action_pressed("dialog_progress"):
		$DialogRunner.dialog_interact()
