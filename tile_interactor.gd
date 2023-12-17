extends Node

@export var player: BallsPlayer = null
@export var tile_map: TileMap = null

func _process(delta: float):
	_process_body(delta, player.ball_a)
	_process_body(delta, player.ball_b)

func _process_body(_delta: float, body: Node2D) -> void:
	var overlapped_tile = tile_map.local_to_map(tile_map.to_local(body.global_position))
	print(tile_map.get_cell_source_id(0, overlapped_tile))
