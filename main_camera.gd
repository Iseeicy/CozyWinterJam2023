extends Camera2D

@export var player: BallsPlayer = null

var _area: Area2D
var _directors: Array[Area2D] = []

func _ready():
	_area = $Area2D
	await get_parent().ready
	_area.reparent(get_parent())

func _physics_process(_delta):
	var middle = player.ball_a.global_position.lerp(player.ball_b.global_position, 0.5)
	_area.global_position = middle
	
	var focus_position = Vector2.ZERO

	if _directors.size() > 0:
		var col_shape: CollisionShape2D = _directors[-1].get_node("CollisionShape2D")
		focus_position = col_shape.global_position
	else:
		focus_position = middle

	global_position = focus_position


func _on_area_2d_area_exited(area: Area2D):
	_directors.erase(area)
	print(_directors.size())

func _on_area_2d_area_entered(area: Area2D):
	_directors.push_back(area)
	print(_directors.size())
