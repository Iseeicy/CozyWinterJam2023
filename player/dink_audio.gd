extends Node2D

#
#	Exports
#

@export var rigidbody: RigidBody2D = null
@export var medium_threshold: float = 40
@export var light_threshold: float = 20
@export var vsoft_threshold: float = 10
@export var none_threshold: float = 3

func _ready():
	rigidbody.body_entered.connect(_on_body_entered.bind())

func _on_body_entered(body: Node):
	var col_vel = rigidbody.linear_velocity
	if "linear_velocity" in body:
		col_vel -= body.linear_velocity

	var player = _get_audio_player(col_vel.length())
	if player: player.play()

func _get_audio_player(mag: float) -> AudioStreamPlayer2D:
	print(mag)
	
	if mag < none_threshold:
		return null
	elif mag < vsoft_threshold:
		return $DinkVSoft
	elif mag < light_threshold:
		return $DinkLight
	elif mag < medium_threshold:
		return $DinkMedium
	else:
		return $DinkHard
