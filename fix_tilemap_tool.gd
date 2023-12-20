extends CanvasLayer


var chosen_file: String = ""
var loaded_tilemap: TileMap = null

@export var old_tileset: TileSet = null
@export var new_tileset: TileSet = null

# Called when the node enters the scene tree for the first time.
func _ready():
	return





#
#	Private Functions
#

func _load_tilemap(path: String):
	var tilemap_scene = load(path)
	loaded_tilemap = tilemap_scene.instantiate()
	get_tree().root.add_child(loaded_tilemap)

func replace_tilemap():
	var old_translation = _create_translation_layer(old_tileset)
	var new_translation = _create_translation_layer(new_tileset)
	
	for layer_id in loaded_tilemap.get_layers_count():
		for tile_pos in loaded_tilemap.get_used_cells(layer_id):
			replace_tile(layer_id, tile_pos, old_translation, new_translation)
	loaded_tilemap.tile_set = new_tileset

	$SaveFileDialog.show()

	# var map_layer: Dictionary = {}
	# for layer_id in loaded_tilemap.get_layers_count():
	# 	var terrain_layers: Dictionary = {}

	# 	for tile_pos in loaded_tilemap.get_used_cells(layer_id):
	# 		var tile_data = loaded_tilemap.get_cell_tile_data(layer_id, tile_pos)
	# 		if not tile_data: continue
	# 		if tile_data.terrain == -1: continue

	# 		var list = terrain_layers.get(tile_data.terrain, [])
	# 		list.push_back(tile_pos)
	# 		terrain_layers[tile_data.terrain] = list

	# 	map_layer[layer_id] = terrain_layers


	# for layer_id in map_layer.keys():
	# 	for terrain in map_layer[layer_id].keys():
	# 		loaded_tilemap.set_cells_terrain_connect(layer_id, map_layer[layer_id][terrain], 1, terrain)
	# 		print("Handled terrain %s on layer %s" % [terrain, layer_id])
	# 		await get_tree().create_timer(0.1).timeout

func replace_tile(layer_id: int, tile_pos: Vector2i, old_translation: Dictionary, new_translation: Dictionary) -> void:
	var atlas_id = loaded_tilemap.get_cell_source_id(layer_id, tile_pos)
	var tile_data = loaded_tilemap.get_cell_tile_data(layer_id, tile_pos)

	if not tile_data: return

	var shared_key = _key_for_tile_data(tile_data)
	if shared_key == "": return

	var old_info: Dictionary = _get_translated_info(old_translation, atlas_id, shared_key)
	var new_info: Dictionary = _get_translated_info(new_translation, atlas_id, shared_key)

	if old_info.size() == 0 or new_info.size() == 0: return

	loaded_tilemap.set_cell(
		layer_id,
		tile_pos,
		new_info["source_id"],
		new_info["atlas_coords"]
	)

func _get_translated_info(transaltion: Dictionary, atlas_id: int, shared_key: String) -> Dictionary:
	return transaltion.get(atlas_id, {}).get(shared_key, {})

## Given a tileset, create a dictionary that allows you to get info about a specific terrain element
## 			Source ID ->
##				Tile Data Key -> {
##					"source_id",
##					"tile_data",
##					"atlas_coords",
## 				}
func _create_translation_layer(tile_set: TileSet) -> Dictionary:
	var data: Dictionary = {} # Source ID -> (Generated Key -> Atlas Coords)

	for tile_source_index in range(0, tile_set.get_source_count()):
		var source = tile_set.get_source(tile_set.get_source_id(tile_source_index))
		if not source is TileSetAtlasSource: continue

		var layer_data: Dictionary = {}	# Generated Key -> Atlas Coords

		for tile_index in range(0, source.get_tiles_count()):
			var tile_data = source.get_tile_data(source.get_tile_id(tile_index), 0)
			var key = _key_for_tile_data(tile_data)

			if key == "": continue

			if key in layer_data.keys(): print("Found dupe - source %s at %s (%s)" % [tile_set.get_source_id(tile_source_index), source.get_tile_id(tile_index), key])
			print("source %s at %s (%s)" % [tile_set.get_source_id(tile_source_index), source.get_tile_id(tile_index), key])

			var info: Dictionary = {}
			info["source_id"] = tile_set.get_source_id(tile_source_index)
			info["tile_data"] = tile_data
			info["atlas_coords"] = source.get_tile_id(tile_index)
			layer_data[key] = info


		data[tile_set.get_source_id(tile_source_index)] = layer_data
	return data

func _key_for_tile_data(tile_data: TileData) -> String:
	if tile_data.terrain == -1 or tile_data.terrain_set == -1: return ""
	
	var key: String = ""

	var cell_neighbor_bits: Array[int] = [
		TileSet.CellNeighbor.CELL_NEIGHBOR_RIGHT_SIDE,
		TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER,
		TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_SIDE,
		TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER,
		TileSet.CellNeighbor.CELL_NEIGHBOR_LEFT_SIDE,
		TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_LEFT_CORNER,
		TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_SIDE,
		TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_RIGHT_CORNER,
	]

	for bit in cell_neighbor_bits:
		key += "%s_" % tile_data.get_terrain_peering_bit(bit)

	return key

#
#	Signals
#

func _on_tilemap_file_dialog_file_selected(path: String):
	chosen_file = path
	$TilemapSelector/ChosenTilemapLabel.text = path
	_load_tilemap(path)

func _on_choose_tilemap_button_pressed():
	$TilemapSelector/TilemapFileDialog.show()


func _on_run_button_pressed():
	replace_tilemap()


func _on_save_file_dialog_file_selected(path):
	var packed_scene = PackedScene.new()
	packed_scene.pack(loaded_tilemap)
	ResourceSaver.save(packed_scene, path)
