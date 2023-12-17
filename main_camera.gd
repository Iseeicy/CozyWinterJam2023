extends Camera2D

@export var player: BallsPlayer = null

func _physics_process(delta):
	var middle = player.ball_a.global_position.lerp(player.ball_b.global_position, 0.5)
	global_position = middle
