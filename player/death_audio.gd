extends Node2D

@export var player: BallsPlayer = null
@export var rigidbody: RigidBody2D = null

func _ready():
	player.killed.connect(_on_killed.bind())

func _on_killed(which_body: RigidBody2D, type: BallsPlayer.KillType):
	if which_body != rigidbody: return

	if type == BallsPlayer.KillType.Shatter:
		$Shatter.play()
		$Spike.play()
	elif type == BallsPlayer.KillType.Zap:
		$Shatter.play()
		$Zap.play()
	elif type == BallsPlayer.KillType.Fall:
		$Fall.play()
