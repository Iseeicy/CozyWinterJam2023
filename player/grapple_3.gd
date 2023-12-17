extends CharacterBody2D
class_name Grapple3

#
#	Enum
#

enum GrappleType {
	Pull,
	Swing
}

enum State {
	Shooting,
	Locked
}

#
#	Exports
#

signal locked(grapple: Grapple3, point: Vector2, normal: Vector2, collider: Object)
signal unlocked(grapple: Grapple3, point: Vector2, normal: Vector2, collider: Object)

@export var shoot_impulse: float = 500
@export var pull_strength: float = 10000
@export var swing_joint_scene: PackedScene = null

#
#	Private Variables
#

@onready var _line: Line2D = $Line2D
var _state: State = State.Shooting
var _impulse: Vector2 = Vector2.ZERO
var _ball: PhysicsBody2D = null
var _grapple_type: GrappleType = GrappleType.Pull 
var _swing_joint: SwingJoint = null

var _locked_point: Vector2
var _locked_normal: Vector2
var _locked_collider: Object

#
#	Godot Functions
#

func _physics_process(delta):
	if _state == State.Shooting:
		var collision = move_and_collide(_impulse * delta)
		if collision: lock(collision.get_position(), collision.get_normal(), collision.get_collider())
	elif _state == State.Locked:
		if _grapple_type == GrappleType.Pull:
			_physics_process_grapple_pull(delta)

	_line.points[1] = to_local(_ball.global_position)

func _physics_process_grapple_pull(delta: float) -> void:
	# Get the vector between us and the player ball
	var direction = (global_position - _ball.global_position).normalized()

	# Draw the player ball towards us!
	_ball.apply_central_force(direction * pull_strength * delta)

#
#	Public Functions
#

func shoot(type: GrappleType, origin_ball: PhysicsBody2D, aim_direction: Vector2) -> void:
	_impulse = aim_direction.normalized() * shoot_impulse
	_ball = origin_ball
	
	global_position = origin_ball.global_position
	global_rotation = aim_direction.angle()

	_state = State.Shooting
	_grapple_type = type

func unshoot() -> void:
	set_physics_process(false)

	if _swing_joint: _swing_joint.queue_free()

	if _state == State.Locked:
		unlocked.emit(self, _locked_point, _locked_normal, _locked_collider)
		
	queue_free()

func lock(point: Vector2, normal: Vector2, collider: Object) -> void:
	global_position = point
	global_rotation = normal.rotated(deg_to_rad(180)).angle()

	_locked_point = point
	_locked_normal = normal
	_locked_collider = collider
	_state = State.Locked

	if _grapple_type == GrappleType.Swing:
		_swing_joint = swing_joint_scene.instantiate()
		get_parent().add_child(_swing_joint)

		_swing_joint.connect_bodies(point, _ball)

	locked.emit(self, point, normal, collider)


#
#	Private Functions
#

