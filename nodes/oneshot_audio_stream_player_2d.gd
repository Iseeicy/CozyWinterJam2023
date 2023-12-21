extends AudioStreamPlayer2D
class_name OneshotAudioStreamPlayer2D

static func quick_play_oneshot(parent: Node2D, audio_stream: AudioStream, point: Vector2) -> OneshotAudioStreamPlayer2D:
	var stream_player = OneshotAudioStreamPlayer2D.new()
	parent.add_child(stream_player)

	stream_player.play_oneshot(audio_stream, point)
	return stream_player

func play_oneshot(audio_stream: AudioStream, point: Vector2):
	finished.connect(_on_finished.bind())

	global_position = point
	stream = audio_stream
	play()

func _on_finished():
	queue_free()
	
