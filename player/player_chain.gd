extends Node2D
class_name PlayerChain

@export var start_joint: PinJoint2D = null
@export var end_joint: PinJoint2D = null

@export var debug_a: Node2D = null
@export var debug_b: Node2D = null

func connect_balls(ball_a: RigidBody2D, ball_b: RigidBody2D) -> void:
	start_joint.node_a = start_joint.get_path_to(ball_a)
	end_joint.node_b = end_joint.get_path_to(ball_b)
