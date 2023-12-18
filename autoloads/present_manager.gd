extends Node

#
#	Exports
#

signal collected_updated(collection: Dictionary)
signal added_present(type: String)

#
#	Private Variables
#

var _collection: Dictionary = {}
var _player: BallsPlayer = null

#
#	Godot Functions
#

func _ready():
	CheckpointManager.player_spawned.connect(_on_player_spawned.bind())
	CheckpointManager.player_despawned.connect(_on_player_despawned.bind())

#
#	Public Functions
#

func collect_present(type: String) -> void:
	_collection[type] = _collection.get(type, 0) + 1
	collected_updated.emit(get_collected())
	added_present.emit(type)

	print("Collected %s" % type)

func reset() -> void:
	_collection.clear()
	collected_updated.emit(get_collected())

func get_collected() -> Dictionary:
	return _collection

#
#	Signals
#

func _on_player_spawned(player: BallsPlayer) -> void:
	_player = player

func _on_player_despawned(__player: BallsPlayer) -> void:
	_player = null