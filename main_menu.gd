extends CanvasLayer

signal start_game()
signal load_game()

func _ready():
	$LoadButton.disabled = not SaveManager.save_file_exists()

func _on_quit_button_pressed():
	$QuitButton/ConfirmationDialog.show()


func _on_confirmation_dialog_canceled():
	$QuitButton/ConfirmationDialog.hide()


func _on_confirmation_dialog_confirmed():
	get_tree().quit()

func _on_load_button_pressed():
	load_game.emit()

func _on_new_game_button_pressed():
	start_game.emit()
