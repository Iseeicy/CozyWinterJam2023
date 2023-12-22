extends Node2D

signal level_completed()

@export var use_debug_spawnpoint: bool = false
@export var debug_spawnpoint: Node2D = null

func _ready():
	if use_debug_spawnpoint:
		await get_tree().create_timer(1.0).timeout
		CheckpointManager.respawn(debug_spawnpoint.global_position)

func _on_end_level_player_trigger_player_entered():
	level_completed.emit()
