extends RigidBody2D
class_name Grapple

#
#	Exports
#

signal shot_grapple()
signal unshot_grapple()
signal locked_grapple()

@export var shoot_impulse: float = 10

#
#	Private Variables
#

@onready var shoot_sound: AudioStreamPlayer2D = $GrappleShoot

var _queue_shoot: bool = false
var _queue_unshoot: bool = false
var _target_origin: Vector2 = Vector2.ZERO
var _target_impulse: Vector2 = Vector2.ZERO
var _monitor_lock: bool = false

var _should_be_visible: bool = false

#
#	Functions
#

func shoot(origin: Vector2, direction: Vector2):
	shoot_sound.play()

	# Cache shoot data so that we can handle it in _integrated_forces
	_target_origin = origin
	_target_impulse = direction * shoot_impulse
	
	freeze = false
	sleeping = false
	_queue_shoot = true
	_monitor_lock = true

func unshoot():
	_should_be_visible = false
	freeze = true
	sleeping = true
	_monitor_lock = false
	_queue_shoot = false
	unshot_grapple.emit()


func _physics_process(_delta):
	if visible != _should_be_visible:
		visible = _should_be_visible

func _integrate_forces(state):

	# Handle shoot physics
	if _queue_shoot:
		state.transform.origin = _target_origin
		state.transform = state.transform.rotated_local(
			_target_impulse.angle() - state.transform.get_rotation()
		)

		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
		state.apply_impulse(_target_impulse)
		
		call_deferred("_on_shoot")
		_queue_shoot = false

	# Handle locking if we hit a wall
	elif _monitor_lock and state.get_contact_count() > 0:
		print("Hit %s" % state.get_contact_collider_object(0))
		
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0

		state.transform.origin = state.get_contact_local_position(0)
		state.transform.rotated(state.get_contact_local_normal(0).angle() - state.transform.get_rotation())

		call_deferred("_on_lock")
		_monitor_lock = false


func _on_shoot() -> void:
	_should_be_visible = true
	shot_grapple.emit()

func _on_lock() -> void:
	freeze = true
	locked_grapple.emit()
