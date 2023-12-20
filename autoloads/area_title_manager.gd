extends CanvasLayer

@export var settings: TextReaderSettings

func show_title(title: String) -> void:
	$TextReaderLabel/TextReader.start_reading("[center][wave]%s[/wave][/center]" % title, settings)
	$FadeOutTimer.start()


func _on_fade_out_timer_timeout():
	$TextReaderLabel/TextReader.cancel_reading()