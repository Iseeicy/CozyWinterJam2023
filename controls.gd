extends CanvasLayer

signal finished() 



func _on_button_pressed():
	finished.emit()
