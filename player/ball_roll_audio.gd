extends AudioStreamPlayer2D

#
#	Exports
#

@export var rigidbody: RigidBody2D = null
@export var volume_mult: float = 1.0
@export var min_pitch: float = 0.9
@export var max_pitch: float = 1.0
@export var pitch_change_speed: float = 1.0
@export var volume_change_speed: float = 1.0
@export var volume_velocity_curve: Curve = Curve.new()

#
#	Private Variables
#

var old_vol: float = 0

#
#	Godot Functions
#

func _physics_process(delta):
	var vol = volume_velocity_curve.sample(clampf(rigidbody.linear_velocity.length() / 100, 0, 1)) * volume_mult
	volume_db = lerpf(old_vol, linear_to_db(vol), delta * volume_change_speed)
	old_vol = vol

	var pitch = lerpf(min_pitch, max_pitch, clampf(rigidbody.linear_velocity.length() / 100.0, 0, 1))
	pitch_scale = lerpf(pitch_scale, pitch, delta * pitch_change_speed)