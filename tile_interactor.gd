extends Node

@export var player: BallsPlayer = null
@export var tile_map: TileMap = null
@export var rules: Array[TileRule] = []

#
#	Godot Functions
#

func _ready():
	player.tile_collided.connect(_on_tile_collided.bind())

func _physics_process(delta: float):
	_process_body(delta, player.ball_a)
	_process_body(delta, player.ball_b)

#
#	Private Functions
#

func _process_body(_delta: float, body: Node2D) -> void:
	# Figure out what tile the body is on
	var overlapped_tile = tile_map.local_to_map(tile_map.to_local(body.global_position))
	var tile_id = tile_map.get_cell_source_id(TileRule.LAYER_GROUND, overlapped_tile)

	# If this body wasn't last on this tile, then call the rules for this tile
	if body.get_meta("last_id", -1)	!= tile_id:
		body.set_meta("last_id", tile_id)

		for rule in _get_rules_for_id(tile_id):
			rule.enter_tile(tile_map, overlapped_tile, body, player)

## Returns an array of rules that apply to the given tile
func _get_rules_for_id(id: int) -> Array[TileRule]:
	var get_by_id = func(rule: TileRule) -> bool:
		return rule.get_tile_id() == id
	
	return rules.filter(get_by_id)

#
#	Signals
#

func _on_tile_collided(hit_tile_map: TileMap, tile_position: Vector2i, body: PhysicsBody2D) -> void:
	# Figure out what tile the body hit
	var tile_id = hit_tile_map.get_cell_source_id(TileRule.LAYER_FOREGROUND, tile_position)

	for rule in _get_rules_for_id(tile_id):
		rule.hit_tile(hit_tile_map, tile_position, body, player)
