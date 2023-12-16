extends Node2D

@export var shoot_sound: AudioStreamPlayer2D
@export var lock_sound: AudioStreamPlayer2D



func _on_grapple_a_locked_grapple():
	shoot_sound.stop()
	lock_sound.play()

func _on_grapple_a_shot_grapple():
	shoot_sound.play()
