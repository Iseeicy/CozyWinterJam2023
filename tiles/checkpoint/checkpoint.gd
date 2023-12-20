extends Area2D
class_name Checkpoint

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var _is_up: bool = false

func _ready():
	set_flag_is_up(false)

func set_flag_is_up(is_up: bool):
	sprite.animation = "up" if is_up else "down"

	if is_up == _is_up: return
	_is_up = is_up

	if _is_up: $LightUpAudio.play()

func _on_body_entered(_body: Node2D):
	CheckpointManager.flag_new_checkpoint(self)
