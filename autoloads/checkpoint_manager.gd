extends Node

signal player_spawned(player: BallsPlayer)
signal player_despawned(player: BallsPlayer)
signal player_reset()
signal checkpoint_flagged()

var spawn_player_on_start: bool = true

var _player_scene: PackedScene = preload("res://player/player.tscn")

var _current_checkpoint: Checkpoint = null
var _current_player: BallsPlayer = null

func _ready():
	await get_tree().root.ready
	if spawn_player_on_start: _spawn_player()

func _spawn_player(override_global_pos = null):
	_current_player = _player_scene.instantiate()
	get_tree().root.add_child(_current_player)
	
	var spawn_point
	if override_global_pos:
		spawn_point = override_global_pos
	else:
		spawn_point = get_spawn_point()
	
	_current_player.respawn(spawn_point)
	player_spawned.emit(_current_player)

func despawn():
	if not _current_player: return
	
	player_despawned.emit(_current_player)
	_current_player.unthrow_grapple_a()
	_current_player.unthrow_grapple_b()
	_current_player.queue_free()
	_current_player = null

func respawn(override_global_pos = null):
	if _current_player: despawn()
		
	_spawn_player(override_global_pos)
	player_reset.emit()

func flag_new_checkpoint(checkpoint: Checkpoint) -> void:
	checkpoint_flagged.emit(checkpoint)
	if _current_checkpoint == checkpoint: return
	if _current_checkpoint: _current_checkpoint.set_flag_is_up(false)

	_current_checkpoint = checkpoint
	if _current_checkpoint.sprite != null:
		_current_checkpoint.set_flag_is_up(true)

func get_spawn_point() -> Vector2:
	if not _current_checkpoint: return Vector2.ZERO
	return _current_checkpoint.global_position

func get_player() -> BallsPlayer:
	return _current_player
