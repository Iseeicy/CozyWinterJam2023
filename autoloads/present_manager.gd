extends Node

#
#	Exports
#

signal collected_updated(held: Dictionary, saved: Dictionary)

#
#	Private Variables
#

var _held_collection: Dictionary = {}
var _saved_collection: Dictionary = {}
var _player: BallsPlayer = null

#
#	Godot Functions
#

func _ready():
	CheckpointManager.player_spawned.connect(_on_player_spawned.bind())
	CheckpointManager.player_despawned.connect(_on_player_despawned.bind())
	CheckpointManager.checkpoint_flagged.connect(_on_checkpoint_flagged.bind())

#
#	Public Functions
#

func collect_present(type: String, tile_pos: Vector2i) -> void:
	var col_arr = _held_collection.get(type, [])
	col_arr.append(tile_pos)
	_held_collection[type] = col_arr
	collected_updated.emit(get_held_collected(), get_saved_collected())

func reset_all() -> void:
	_held_collection.clear()
	_saved_collection.clear()
	collected_updated.emit(get_held_collected(), get_saved_collected())

func get_held_collected() -> Dictionary:
	return _held_collection

func get_saved_collected() -> Dictionary:
	return _saved_collection

#
#	Private Functions
#

func _drop_held():
	_held_collection.clear()
	collected_updated.emit(get_held_collected(), get_saved_collected())

func _empty_held_into_saved():
	for key in _held_collection.keys():
		var arr = _saved_collection.get(key, [])
		arr.append_array(_held_collection[key])
		_saved_collection[key] = arr
	_held_collection.clear()
	collected_updated.emit(get_held_collected(), get_saved_collected())

#
#	Signals
#

func _on_player_spawned(player: BallsPlayer) -> void:
	_player = player

func _on_player_despawned(__player: BallsPlayer) -> void:
	_player = null
	_drop_held()

func _on_checkpoint_flagged(_checkpoint: Checkpoint) -> void:
	_empty_held_into_saved()
