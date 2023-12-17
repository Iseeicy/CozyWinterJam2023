extends Node2D
class_name BallsPlayer

enum KillType {
	Shatter,
	Fall,
	Zap
}

#
#	Exports
#

signal tile_collided(tile_map: TileMap, tile_position: Vector2i, ball: PhysicsBody3D)
signal killed(which_body: RigidBody2D, type: KillType)
signal grapple_locked(grapple: Grapple3, point: Vector2, normal: Vector2, collider: Object)
signal grapple_unlocked(grapple: Grapple3, point: Vector2, normal: Vector2, collider: Object)

@export var grapple_scene: PackedScene = null
@export var explode_particle_scene: PackedScene = null
@export var zap_particles_scene: PackedScene = null
@export var fall_particles_scene: PackedScene = null

#
#	Private Variables
#

@onready var ball_a: RigidBody2D = $BallA
@onready var ball_b: RigidBody2D = $BallB
@onready var default_friction: float = ball_a.linear_damp
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
	grapple_a.locked.connect(_on_grapple_locked.bind())
	
	grapple_a.shoot(Grapple3.GrappleType.Pull, ball_a, get_global_mouse_position() - ball_a.global_position)

func unthrow_grapple_a():
	if not grapple_a: return
	
	grapple_a.unshoot()
	grapple_a = null

func throw_grapple_b():
	if grapple_b: return
	
	grapple_b = grapple_scene.instantiate()
	get_parent().add_child(grapple_b)
	grapple_b.locked.connect(_on_grapple_locked.bind())

	grapple_b.shoot(Grapple3.GrappleType.Swing, ball_b, get_global_mouse_position() - ball_b.global_position)

func unthrow_grapple_b():
	if not grapple_b: return

	grapple_b.unshoot()
	grapple_b = null

func unthrow_grapple(grapple: Grapple3):
	if grapple == grapple_a: unthrow_grapple_a()
	if grapple == grapple_b: unthrow_grapple_b()

func kill(which_body: RigidBody2D, type: KillType) -> void:
	set_process_unhandled_input(false)
	unthrow_grapple_a()
	unthrow_grapple_b()
	
	ball_a.set_physics_process(false)
	ball_b.set_physics_process(false)

	if which_body.visible:
		if type == KillType.Zap:
			var particles = zap_particles_scene.instantiate()
			get_parent().add_child(particles)
			particles.global_position = which_body.global_position
			for child in particles.get_children():
				child.emitting = true

			var kill_particle = func():
				particles.queue_free()
			get_tree().create_timer(4).timeout.connect(kill_particle.bind())
		elif type == KillType.Fall:
			var particles = fall_particles_scene.instantiate()
			get_parent().add_child(particles)
			particles.global_position = which_body.global_position
			for child in particles.get_children():
				child.emitting = true

			var kill_particle = func():
				particles.queue_free()
			get_tree().create_timer(4).timeout.connect(kill_particle.bind())
		else:
			var particle = explode_particle_scene.instantiate()
			get_parent().add_child(particle)
			particle.global_position = which_body.global_position
			particle.emitting = true

			var kill_particle = func():
				particle.queue_free()
			get_tree().create_timer(4).timeout.connect(kill_particle.bind())
	which_body.hide()
	# ball_a.hide()
	# ball_b.hide()
	
	for node in $Chain.get_children():
		if node is PinJoint2D:
			node.queue_free()

	killed.emit(which_body, type)


func _on_ball_b_body_shape_entered(body_rid:RID, body: Node, _body_shape_index:int, _local_shape_index:int):
	if not body is TileMap: return
	tile_collided.emit(body, body.get_coords_for_body_rid(body_rid), ball_b)

func _on_ball_a_body_shape_entered(body_rid:RID, body: Node, _body_shape_index:int, _local_shape_index:int):
	if not body is TileMap: return
	tile_collided.emit(body, body.get_coords_for_body_rid(body_rid), ball_a)

func _on_grapple_locked(grapple: Grapple3, point: Vector2, normal: Vector2, collider: Object):
	grapple_locked.emit(grapple, point, normal, collider)

func _on_grapple_unlocked(grapple: Grapple3, point: Vector2, normal: Vector2, collider: Object):
	grapple_unlocked.emit(grapple, point, normal, collider)
