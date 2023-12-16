extends Node2D

#
#	Exports
#


#
#	Private Variables
#

@onready var ball_a: PhysicsBody2D = $BallA
@onready var ball_b: PhysicsBody2D = $BallB
@onready var grapple_a: Grapple = $GrappleA
@onready var grapple_b: Grapple = $GrappleB

#
#	Godot Functions
#

func _unhandled_input(event):
	if event.is_action_pressed("shoot_hook_a"):
		throw_grapple_a()
	if event.is_action_released("shoot_hook_a"):
		unthrow_grapple_a()
	if event.is_action_pressed("shoot_hook_b"):
		throw_grapple_b()
	if event.is_action_released("shoot_hook_b"):
		unthrow_grapple_b()

#
#	Functions
#

func throw_grapple_a():
	var direction = get_global_mouse_position() - ball_a.global_position
	direction = direction.normalized()
	
	grapple_a.shoot(ball_a.global_position, direction)

func unthrow_grapple_a():
	grapple_a.unshoot()

func throw_grapple_b():
	var direction = get_global_mouse_position() - ball_b.global_position
	direction = direction.normalized()
	
	grapple_b.shoot(ball_b.global_position, direction)

func unthrow_grapple_b():
	grapple_b.unshoot()
