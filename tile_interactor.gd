extends Node

@export var player: BallsPlayer = null
@export var tile_map: TileMap = null
@export var rules: Array[TileRule] = []

#
#	Godot Functions
#

func _ready():
	player.tile_collided.connect(_on_tile_collided.bind())
	player.grapple_locked.connect(_on_grapple_locked.bind())
	player.grapple_unlocked.connect(_on_grapple_unlocked.bind())

func _physics_process(delta: float):
	_process_body(delta, player.ball_a)
	_process_body(delta, player.ball_b)

#
#	Private Functions
#

func _process_body(_delta: float, body: Node2D) -> void:
	for layer in tile_map.get_layers_count():
		# Figure out what tile the body is on
		var overlapped_tile = tile_map.local_to_map(tile_map.to_local(body.global_position))
		var tile_id = tile_map.get_cell_source_id(layer, overlapped_tile)
		var last_id = body.get_meta("lay%s_last_id" % layer, -1)
		var last_tile_pos = body.get_meta("lay%s_last_tile_pos" % layer, overlapped_tile)

		# If this body wasn't last on this tile, then call the rules for this tile
		if last_id	!= tile_id:
			for rule in _get_rules_for_id(last_id):
				rule.exit_tile(tile_map, layer, last_tile_pos, body, player)
			
			body.set_meta("lay%s_last_id" % layer, tile_id)
			body.set_meta("lay%s_last_tile_pos" % layer, overlapped_tile)

			for rule in _get_rules_for_id(tile_id):
				rule.enter_tile(tile_map, layer, overlapped_tile, body, player)

## Returns an array of rules that apply to the given tile
func _get_rules_for_id(id: int) -> Array[TileRule]:
	var get_by_id = func(rule: TileRule) -> bool:
		return rule.get_tile_id() == id
	
	return rules.filter(get_by_id)

#
#	Signals
#

func _on_tile_collided(hit_tile_map: TileMap, tile_position: Vector2i, body: PhysicsBody2D) -> void:
	for layer in tile_map.get_layers_count():
		# Figure out what tile the body hit
		var tile_id = hit_tile_map.get_cell_source_id(layer, tile_position)

		for rule in _get_rules_for_id(tile_id):
			rule.hit_tile(hit_tile_map, layer, tile_position, body, player)

func _on_grapple_locked(grapple: Grapple3, point: Vector2, normal: Vector2, _collider: Object):
	for layer in tile_map.get_layers_count():
		# Figure out what tile the body is on
		var overlapped_tile = tile_map.local_to_map(tile_map.to_local(point - normal))
		var tile_id = tile_map.get_cell_source_id(layer, overlapped_tile)

		for rule in _get_rules_for_id(tile_id):
			rule.grapple_locked_tile(tile_map, layer, overlapped_tile, grapple, point, normal, player)

func _on_grapple_unlocked(grapple: Grapple3, point: Vector2, normal: Vector2, _collider: Object):
	for layer in tile_map.get_layers_count():
		# Figure out what tile the body is on
		var overlapped_tile = tile_map.local_to_map(tile_map.to_local(point - normal))
		var tile_id = tile_map.get_cell_source_id(layer, overlapped_tile)

		for rule in _get_rules_for_id(tile_id):
			rule.grapple_unlocked_tile(tile_map, layer, overlapped_tile, grapple, point, normal, player)
