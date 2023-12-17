extends Area2D
class_name Checkpoint

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	set_flag_is_up(false)

func set_flag_is_up(is_up: bool):
	sprite.animation = "up" if is_up else "down"

func _on_body_entered(_body: Node2D):
	CheckpointManager.flag_new_checkpoint(self)
