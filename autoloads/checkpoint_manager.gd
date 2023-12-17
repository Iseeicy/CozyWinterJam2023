extends Node

signal player_spawned(player: BallsPlayer)
signal player_despawned(player: BallsPlayer)
signal player_reset()

var _player_scene: PackedScene = preload("res://player/player.tscn")

var _current_checkpoint: Checkpoint = null
var _current_player: BallsPlayer = null

func _ready():
	await get_tree().root.ready
	_spawn_player()


func _spawn_player():
	_current_player = _player_scene.instantiate()
	get_tree().root.add_child(_current_player)
	_current_player.respawn(get_spawn_point())
	player_spawned.emit(_current_player)

func respawn():
	if _current_player:
		player_despawned.emit(_current_player)
		_current_player.queue_free()
		_current_player = null
	
	_spawn_player()
	player_reset.emit()

func flag_new_checkpoint(checkpoint: Checkpoint) -> void:
	if _current_checkpoint == checkpoint: return
	if _current_checkpoint: _current_checkpoint.set_flag_is_up(false)
	
	_current_checkpoint = checkpoint
	_current_checkpoint.set_flag_is_up(true)

func get_spawn_point() -> Vector2:
	if not _current_checkpoint: return Vector2.ZERO
	return _current_checkpoint.global_position