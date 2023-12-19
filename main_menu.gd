extends Control

signal start_game()


func _on_quit_button_pressed():
	$HBoxContainer/QuitButton/ConfirmationDialog.show()


func _on_confirmation_dialog_canceled():
	$HBoxContainer/QuitButton/ConfirmationDialog.hide()


func _on_confirmation_dialog_confirmed():
	get_tree().quit()


func _on_new_game_button_pressed():
	start_game.emit()
