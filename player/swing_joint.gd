extends Node2D
class_name SwingJoint

var pin_joint: PinJoint2D:
	get:
		return $PinJoint2D

var groove_joint: GrooveJoint2D:
	get:
		return $GrooveJoint2D

var anchor: StaticBody2D:
	get:
		return $Anchor

var rotator: RigidBody2D:
	get:
		return $Rotator

func connect_bodies(origin_point: Vector2, swing_body: PhysicsBody2D) -> void:
	var aim_direction = (swing_body.global_position - origin_point)

	anchor.global_position = origin_point
	rotator.global_position = origin_point
	pin_joint.global_position = origin_point
	groove_joint.global_position = origin_point

	groove_joint.global_rotation = aim_direction.rotated(deg_to_rad(-90)).angle()
	groove_joint.length = aim_direction.length() + 1
	groove_joint.initial_offset = aim_direction.length()
	groove_joint.node_a = groove_joint.get_path_to(rotator)
	groove_joint.node_b = groove_joint.get_path_to(swing_body)

func disconnect_body() -> void:
	groove_joint.node_b = NodePath()
