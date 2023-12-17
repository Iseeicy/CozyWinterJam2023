extends RigidBody2D
class_name GrappleRope

#
#	Enum
#

enum GrappleType {
	Pull,
	Swing
}

#
#	Exports
#

signal shot_grapple()
signal unshot_grapple()
signal locked_grapple()
signal link_added(is_locked: bool, link_count: int)
signal link_removed(is_locked: bool, link_count: int)

@export var shoot_impulse: float = 10
@export var pull_strength: float = 10
@export var parent_ball: RigidBody2D = null

@export var link_scene: PackedScene = null
@export var stick_force: float = 10000
@export var fly_force: float = 10000
@export var closeness_threshold: float = 10
@export var grapple_type: GrappleType = GrappleType.Pull

#
#	Private Variables
#

const link_length = 8
var _links: Array[PinJoint2D] = []
var _queue_shoot: bool = false
var _target_origin: Vector2 = Vector2.ZERO
var _target_impulse: Vector2 = Vector2.ZERO
var _monitor_lock: bool = false
var _is_locked: bool = false

#
#	Public Functions
#

func shoot(origin: Vector2, direction: Vector2):
	# Cache shoot data so that we can handle it in _integrated_forces
	_target_origin = origin
	_target_impulse = direction * shoot_impulse

	freeze = false
	sleeping = false
	_queue_shoot = true
	_monitor_lock = true
	_is_locked = false

func unshoot():
	set_physics_process(false)
	for link in _links:
		link.queue_free()
		link.get_node(link.node_b).queue_free()
	queue_free()
	
#
#	Godot Functions
#

func _physics_process(delta):
	# Make the last link retract towards the origin
	if _links.size() > 0:
		var last_link: RigidBody2D = _get_last_link()
		var aim_direction: Vector2 = (parent_ball.global_position - last_link.global_position).normalized()
		var cur_stick_force = stick_force if _is_locked else stick_force * 1.0
		last_link.apply_central_force(aim_direction * cur_stick_force * delta)

	while _links.size() > 0 and _get_last_link_distance() < closeness_threshold and (grapple_type != GrappleType.Swing or not _is_locked):
		_remove_link()
	while _get_last_link_distance() - (link_length) > closeness_threshold and (not _is_locked  or _get_rope_length() < _get_min_possible_length() or grapple_type != GrappleType.Pull):
		_add_link()

	if _is_locked and grapple_type == GrappleType.Pull:
		var target_link = _get_last_link()
		if not target_link: target_link = self
		
		# Get the vector between us and the player ball
		var direction = target_link.global_position - parent_ball.global_position
		direction = direction.normalized()

		# Draw the player ball towards us!
		parent_ball.apply_central_force(direction * pull_strength * delta)

func _integrate_forces(state):

	# Handle shoot physics
	if _queue_shoot:
		state.transform.origin = _target_origin
		# state.transform.origin = Vector2(60, 20)
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

		for link in _links:
			var connected = link.get_node(link.node_b)
			connected.linear_velocity = Vector2.ZERO
			connected.angular_velocity = 0

		call_deferred("_on_lock")
		_monitor_lock = false


func _on_shoot() -> void:
	shot_grapple.emit()

func _on_lock() -> void:
	freeze = true
	_is_locked = true

	if grapple_type == GrappleType.Swing:
		var last_link = _get_last_link()
		
		# Create the joint
		var new_joint: PinJoint2D = PinJoint2D.new()
		get_parent().add_child(new_joint)
		new_joint.bias = 0.7
		new_joint.softness = 2
		new_joint.global_position = parent_ball.global_position.lerp(last_link.global_position, 0.5)

		# Join the link
		new_joint.node_a = new_joint.get_path_to(parent_ball)
		new_joint.node_b = new_joint.get_path_to(last_link)
		_links.push_back(new_joint)

		
	locked_grapple.emit()


func _add_link():
	# Find out where to attach the new link
	var previous_body: PhysicsBody2D
	if _links.size() > 0:
		previous_body = _links[-1].get_node(_links[-1].node_b)
	else:
		previous_body = self

	# Create the visible link
	var new_link: RigidBody2D = link_scene.instantiate()
	get_parent().add_child(new_link)
	new_link.global_position = previous_body.global_position - (Vector2.RIGHT.rotated(previous_body.global_rotation) * link_length)
	new_link.global_rotation = previous_body.global_rotation
	new_link.linear_velocity = previous_body.linear_velocity * 1.0
	
	# Create the joint
	var new_joint: PinJoint2D = PinJoint2D.new()
	get_parent().add_child(new_joint)
	new_joint.bias = 0.7
	new_joint.softness = 2
	new_joint.global_position = new_link.global_position.lerp(previous_body.global_position, 0.5)

	# Rotate link to face towards origin
	var aim_direction: Vector2 = (new_joint.global_position - parent_ball.global_position)
	new_link.global_position = new_joint.global_position + (new_link.global_position - new_joint.global_position).rotated(aim_direction.angle() - new_link.global_rotation)
	new_link.global_rotation = aim_direction.angle()


	# Join the link
	new_joint.node_a = new_joint.get_path_to(previous_body)
	new_joint.node_b = new_joint.get_path_to(new_link)

	_links.push_back(new_joint)
	link_added.emit(_is_locked, _links.size())

	
func _remove_link():
	# If there are no links, exit early
	if _links.size() == 0: return

	# Get the last link
	var last_link: PinJoint2D = _links.pop_back()

	# Free it up!
	last_link.get_node(last_link.node_b).queue_free()
	last_link.queue_free()
	link_removed.emit(_is_locked, _links.size())

func _get_rope_length() -> float:
	return link_length + (_links.size() * link_length)

func _get_min_possible_length() -> float:
	return (parent_ball.global_position - global_position).length() + link_length

func _get_last_link() -> RigidBody2D:
	if _links.size() == 0: return null
	
	var last_joint: PinJoint2D = _links[-1]
	return last_joint.get_node(last_joint.node_b)

func _get_last_link_distance() -> float:
	if _links.size() == 0: return _get_min_possible_length()
	
	return (_get_last_link().global_position - parent_ball.global_position).length()
