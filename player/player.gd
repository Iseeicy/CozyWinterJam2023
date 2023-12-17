extends Node2D
class_name BallsPlayer

#
#	Exports
#

@export var grapple_scene: PackedScene = null

#
#	Private Variables
#

@onready var ball_a: PhysicsBody2D = $BallA
@onready var ball_b: PhysicsBody2D = $BallB
var grapple_a: Grapple3 = null
var grapple_b: Grapple3 = null

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
	if grapple_a: return
	
	grapple_a = grapple_scene.instantiate()
	get_parent().add_child(grapple_a)
	
	grapple_a.shoot(Grapple3.GrappleType.Pull, ball_a, get_global_mouse_position() - ball_a.global_position)

func unthrow_grapple_a():
	if not grapple_a: return
	
	grapple_a.unshoot()
	grapple_a = null

func throw_grapple_b():
	if grapple_b: return
	
	grapple_b = grapple_scene.instantiate()
	get_parent().add_child(grapple_b)

	grapple_b.shoot(Grapple3.GrappleType.Swing, ball_b, get_global_mouse_position() - ball_b.global_position)

func unthrow_grapple_b():
	if not grapple_b: return

	grapple_b.unshoot()
	grapple_b = null
