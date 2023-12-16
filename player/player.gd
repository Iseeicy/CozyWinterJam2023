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

#
#	Godot Functions
#

func _unhandled_input(event):
	if event.is_action_pressed("shoot_hook_a"):
		throw_grapple_a()


func _physics_process(delta):
	if Input.is_action_pressed("shoot_hook_b"):
		var force = get_global_mouse_position() - ball_a.global_position
		force = force.normalized()
		ball_a.apply_central_force(force * 100000 * delta);

#
#	Functions
#

func throw_grapple_a():
	var direction = get_global_mouse_position() - ball_a.global_position
	direction = direction.normalized()
	
	grapple_a.shoot(ball_a.global_position, direction)
