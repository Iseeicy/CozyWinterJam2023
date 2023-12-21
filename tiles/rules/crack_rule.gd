extends TileRule
class_name CrackRule

#
#   Exports
#

## When the player touches a crack, after this many seconds, the crack will become a pit.
@export var time_until_crumble: float = 2.0

## The sound to play when crumbling begins
@export var crumble_start_sound: AudioStream = null

## The sound to play when crumbling has completed
@export var crumble_complete_sound: AudioStream = null

#
#   Private Variables
#

var _changed_tiles: Dictionary = {}

#
#   Virtual Methods
#

func get_tile_id() -> int:
	return ID_CRACK

func enter_tile(tile_map: TileMap, layer: int, position: Vector2i, _body: RigidBody2D, _player: BallsPlayer) -> void:
	if get_is_handling(position): return
	set_is_handling(position, true)
	
	play_oneshot_at_tile(tile_map, position, crumble_start_sound)
	await tile_map.get_tree().create_timer(time_until_crumble).timeout
	
	play_oneshot_at_tile(tile_map, position, crumble_complete_sound)
	_save_original_tile_state(tile_map, layer, position)
	
	tile_map.set_cell(
		layer, 
		position, 
		ID_PIT, 
		tile_map.get_cell_atlas_coords(layer, position),
		tile_map.get_cell_alternative_tile(layer, position)
	)

	set_is_handling(position, false)

func reset():
	for layer_dict in _changed_tiles.values():
		for position_dict in layer_dict.values():
			var tile_map: TileMap = position_dict["tile_map"]

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
	layer_dict[position] = position_dict
	_changed_tiles[layer] = layer_dict
