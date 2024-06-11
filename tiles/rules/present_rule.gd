extends TileRule
class_name PresentRule

#
#   Exports
#

## The sound to play when collecting a present
@export var present_collect_sound: AudioStream = null

#
#   Private Variables
#

var _changed_tiles: Dictionary = {}

#
#   Virtual Methods
#

func get_tile_id() -> int:
	return ID_PRESENT

func enter_tile(tile_map: TileMap, layer: int, position: Vector2i, _body: RigidBody2D, _player: BallsPlayer) -> void:
	play_oneshot_at_tile(tile_map, position, present_collect_sound)
	
	_save_original_tile_state(tile_map, layer, position)
	PresentManager.collect_present(
		tile_map.get_cell_tile_data(layer, position).get_custom_data("currency_type"), 
		position,
		tile_map.to_global(tile_map.map_to_local(position))
	)

	tile_map.set_cell(
		layer, 
		position, 
		-1, 
	)

	set_is_handling(position, false)

func reset():
	for layer_dict in _changed_tiles.values():
		for position_dict in layer_dict.values():
			var tile_map: TileMap = position_dict["tile_map"]
			var currency_type = position_dict["currency_type"]
			
			var tiles_to_not_reset = []
			tiles_to_not_reset.append_array(PresentManager.get_held_collected().get(currency_type, []))
			tiles_to_not_reset.append_array(PresentManager.get_saved_collected().get(currency_type, []))

			if position_dict["position"] in tiles_to_not_reset: continue

			tile_map.set_cell(
				position_dict["layer"], 
				position_dict["position"], 
				position_dict["tile_id"], 
				position_dict["atlas_coords"],
				position_dict["alt_tile"]
			)
	_changed_tiles.clear()

func _save_original_tile_state(tile_map: TileMap, layer: int, position: Vector2i) -> void:
	var layer_dict = _changed_tiles.get(layer, {})
	var position_dict = layer_dict.get(position, {})
	position_dict["tile_map"] = tile_map
	position_dict["layer"] = layer
	position_dict["position"] = position
	position_dict["tile_id"] = tile_map.get_cell_source_id(layer, position)
	position_dict["atlas_coords"] = tile_map.get_cell_atlas_coords(layer, position)
	position_dict["alt_tile"] = tile_map.get_cell_alternative_tile(layer, position)
	position_dict["currency_type"] = tile_map.get_cell_tile_data(layer, position).get_custom_data("currency_type")
	
	layer_dict[position] = position_dict
	_changed_tiles[layer] = layer_dict

