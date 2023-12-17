extends TileRule
class_name PresentRule

#
#   Exports
#

## The sound to play when collecting a present
@export var present_collect_sound: AudioStream = null

#
#   Virtual Methods
#

func get_tile_id() -> int:
	return ID_PRESENT

func enter_tile(tile_map: TileMap, position: Vector2i, _body: RigidBody2D, _player: BallsPlayer) -> void:
	play_oneshot_at_tile(tile_map, position, present_collect_sound)
	
	PresentManager.collect_present(tile_map.get_cell_tile_data(TileRule.LAYER_GROUND, position).get_custom_data("currency_type"))
	tile_map.set_cell(
		TileRule.LAYER_GROUND, 
		position, 
		-1, 
	)
	
	set_is_handling(position, false)
