extends RigidBody2D

@export var origin_node: PhysicsBody2D = null
@export var link_scene: PackedScene = null
@export var stick_force: float = 10000
@export var fly_force: float = 10000
@export var closeness_threshold: float = 10

@export var target_link_count: int = 3

const link_length = 8

var _links: Array[PinJoint2D] = []

func _physics_process(delta):
	var fly_direction: Vector2 = (get_global_mouse_position() - global_position)
	apply_central_force(fly_direction * fly_force * delta)
	
	# if _links.size() < target_link_count:
	# 	_add_link()
	# elif _links.size() > target_link_count:
	# 	_remove_link()

	if _links.size() > 0:
		var last_link: RigidBody2D = _get_last_link()
		
		var aim_direction: Vector2 = (origin_node.global_position - last_link.global_position).normalized()
		last_link.apply_central_force(aim_direction * stick_force * delta)

	while _links.size() > 0 and _get_last_link_distance() < closeness_threshold:
		_remove_link()
	while _get_last_link_distance() - (link_length / 2.0) > closeness_threshold:
		_add_link()


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
	new_link.global_position = previous_body.global_position + (Vector2.RIGHT.rotated(previous_body.global_rotation) * link_length / 2.0)
	new_link.global_rotation = previous_body.global_rotation
	# new_link.global_rotation = aim_direction.angle()

	# Create the joint
	var new_joint: PinJoint2D = PinJoint2D.new()
	get_parent().add_child(new_joint)
	new_joint.global_position = new_link.global_position.lerp(previous_body.global_position, 0.5)

	# Join the link
	new_joint.node_a = new_joint.get_path_to(previous_body)
	new_joint.node_b = new_joint.get_path_to(new_link)
	_links.push_back(new_joint)

	# Rotate link to face towards origin
	var aim_direction: Vector2 = (origin_node.global_position - new_joint.global_position).normalized()
	new_link.global_position = new_link.global_position + (new_joint.global_position - new_link.global_position).rotated(aim_direction.angle())
	new_link.global_rotation = aim_direction.angle()
	
func _remove_link():
	# If there are no links, exit early
	if _links.size() == 0: return

	# Get the last link
	var last_link: PinJoint2D = _links.pop_back()

	# Free it up!
	last_link.get_node(last_link.node_b).queue_free()
	last_link.queue_free()

func _get_rope_length() -> float:
	return link_length + (_links.size() * link_length)

func _get_min_possible_length() -> float:
	return (origin_node.global_position - global_position).length() + link_length

func _get_last_link() -> RigidBody2D:
	if _links.size() == 0: return null
	
	var last_joint: PinJoint2D = _links[-1]
	return last_joint.get_node(last_joint.node_b)

func _get_last_link_distance() -> float:
	if _links.size() == 0: return _get_min_possible_length()
	
	return (_get_last_link().global_position - origin_node.global_position).length()
