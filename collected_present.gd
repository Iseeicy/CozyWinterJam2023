extends Node2D
class_name CollectedPresent

@export var float_speed: float = 10

var _target_node: Node2D = null
var _deposit_mode: bool = false
var _is_dying: bool = false
var _target_position: Vector2 = Vector2.ZERO
var _rotator: float = 0
var _rotate_distance: float = 25

func _process(delta):
	_rotator += deg_to_rad(200 * delta)
	
	if _target_node:
		if not _deposit_mode:
			var angle_vec = global_position - _target_node.global_position
			_target_position = _target_node.global_position + (angle_vec.normalized() * 15)
		else:
			_target_position = _target_node.global_position + (Vector2.UP.rotated(_rotator) * _rotate_distance)
			if not _is_dying and (global_position - _target_position).length() < 30:
				fade_out()

	global_position = global_position.lerp(_target_position, float_speed * delta)

func target(node: Node2D):
	_target_node = node

func deposit(node: Node2D, index: int, total: int):
	_target_node = node
	_deposit_mode = true
	_rotator = deg_to_rad((index as float / total as float) * 360.0)
	_rotate_distance = 25

func fade_out():
	_is_dying = true
	await get_tree().create_timer(3).timeout
	_rotate_distance = 0
	await get_tree().create_timer(0.7).timeout
	queue_free()

func set_type(type: String):
	if type.contains("red"):
		$AnimatedSprite2D.modulate = Color.RED
	elif type.contains("green"):
		$AnimatedSprite2D.modulate = Color.GREEN
	elif type.contains("blue"):
		$AnimatedSprite2D.modulate = Color.BLUE
	elif type.contains("cyan"):
		$AnimatedSprite2D.modulate = Color.CYAN
	elif type.contains("yellow"):
		$AnimatedSprite2D.modulate = Color.YELLOW
	elif type.contains("magenta"):
		$AnimatedSprite2D.modulate = Color.MAGENTA
	elif type.contains("mint"):
		$AnimatedSprite2D.modulate = Color.html("45ffb1")
	elif type.contains("orange"):
		$AnimatedSprite2D.modulate = Color.html("ff9429")
	elif type.contains("pink"):
		$AnimatedSprite2D.modulate = Color.html("ff3ba7")
	elif type.contains("charcoal"):
		$AnimatedSprite2D.modulate = Color.html("616161")