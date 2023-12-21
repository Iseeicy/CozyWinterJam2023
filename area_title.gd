extends Area2D

@export var text: String = ""
var _body_stack: Array[Node2D] = []

var _can_display: bool = false

func _ready():
	CheckpointManager.player_spawned.connect(_on_player_spawned.bind())
	CheckpointManager.player_despawned.connect(_on_player_despawned.bind())

#
#	Signals
#

func _on_player_spawned(_player: BallsPlayer):
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	_can_display = true

func _on_player_despawned(_player: BallsPlayer):
	_can_display = false

func _on_body_exited(body: Node2D):
	_body_stack.erase(body)
	
func _on_body_entered(body: Node2D):
	_body_stack.push_back(body)
	print("mar")

	if _body_stack.size() == 1 and _can_display:
		AreaTitleManager.show_title(text)
