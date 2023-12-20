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
	Locked,
	MaxLength,
	GoingBack
}

#
#	Exports
#

signal locked(grapple: Grapple3, point: Vector2, normal: Vector2, collider: Object)
signal unlocked(grapple: Grapple3, point: Vector2, normal: Vector2, collider: Object)

@export var shoot_impulse: float = 500
@export var pull_strength: float = 10000
@export var max_grapple_length: float = 250
@export var max_grapple_length_timeout: float = 0.2

#
#	Private Variables
#

@onready var _line: Line2D = $Line2D
var _state: State = State.Shooting
var _impulse: Vector2 = Vector2.ZERO
var _ball: PhysicsBody2D = null
var _grapple_type: GrappleType = GrappleType.Pull 
var _swing_joint: PinJoint2D = null

var _locked_point: Vector2
var _locked_normal: Vector2
var _locked_collider: Object

#
#	Godot Functions
#

func _physics_process(delta):
	if _state == State.Shooting:
		if (global_position - _ball.global_position).length() > max_grapple_length:
			hit_max_length()
			return

		var collision = move_and_collide(_impulse * delta)
		if collision: lock(collision.get_position(), collision.get_normal(), collision.get_collider())
	elif _state == State.GoingBack:
		var aim_dir = (_ball.global_position - global_position).normalized()
		
		var collision = move_and_collide(aim_dir * _impulse.length() * delta)
		if collision or (_ball.global_position - global_position).length() < 20:
			finish_retract()
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
	$Audio/Throw.play()
	$Audio/Chaining.play()

func unshoot() -> void:
	set_physics_process(false)

	if _swing_joint:
		_swing_joint.get_node(_swing_joint.node_a).queue_free()
		_swing_joint.queue_free()
		_swing_joint = null

	if _state == State.Locked:
		unlocked.emit(self, _locked_point, _locked_normal, _locked_collider)
		
	$Audio/Chaining.stop()
	queue_free()

func lock(point: Vector2, normal: Vector2, collider: Object) -> void:
	global_position = point
	global_rotation = normal.rotated(deg_to_rad(180)).angle()

	_locked_point = point
	_locked_normal = normal
	_locked_collider = collider
	_state = State.Locked

	if _grapple_type == GrappleType.Swing:
		var static_bod = StaticBody2D.new()
		get_parent().add_child(static_bod)
		static_bod.global_position = point

		_swing_joint = PinJoint2D.new()
		get_parent().add_child(_swing_joint)
		_swing_joint.global_position = point
		_swing_joint.node_a = _swing_joint.get_path_to(static_bod)
		_swing_joint.node_b = _swing_joint.get_path_to(_ball)

	$Audio/Chaining.stop()
	$Audio/Lock.play()
	locked.emit(self, point, normal, collider)

func hit_max_length():
	_state = State.MaxLength

	await get_tree().create_timer(max_grapple_length_timeout).timeout
	retract()

func retract():
	_state = State.GoingBack

func finish_retract():
	_ball.get_parent().unthrow_grapple(self)
	


#
#	Private Functions
#

