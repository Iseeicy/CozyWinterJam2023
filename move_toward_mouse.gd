extends RigidBody2D

@export var move_force: float = 10000

func _physics_process(delta):
	if Input.is_action_pressed("shoot_hook_a"):
		apply_central_force((get_global_mouse_position() - global_position).normalized() * move_force * delta)
