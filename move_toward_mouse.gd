extends RigidBody2D

@export var move_force: float = 10000

func _physics_process(delta):
	apply_central_force((get_global_mouse_position() - global_position).normalized() * move_force * delta)
