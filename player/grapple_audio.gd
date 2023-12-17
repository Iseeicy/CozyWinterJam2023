extends Node2D

@export var shoot_sound: AudioStreamPlayer2D
@export var lock_sound: AudioStreamPlayer2D
@export var chain_eat_sound: AudioStreamPlayer2D



func _on_grapple_rope_locked_grapple():
	shoot_sound.stop()
	lock_sound.play()
	chain_eat_sound.pitch_scale = 0.5

func _on_grapple_rope_shot_grapple():
	shoot_sound.play()

func _on_grapple_rope_link_removed(is_locked: bool, _count: int):
	if is_locked:
		chain_eat_sound.pitch_scale += 0.01
		chain_eat_sound.play()
