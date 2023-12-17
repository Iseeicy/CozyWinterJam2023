extends TileRule
class_name SnowRule

#
#   Exports
#

## How much to linear damp a player ball while it's crossing a snow tile
@export var snow_dampen: float = 5

#
#   Virtual Methods
#

func get_tile_id() -> int:
    return ID_SNOW

func enter_tile(_tile_map: TileMap, _layer: int, _position: Vector2i, body: RigidBody2D, _player: BallsPlayer) -> void:
    body.linear_damp = snow_dampen

func exit_tile(_tile_map: TileMap, _layer: int, _position: Vector2i, body: RigidBody2D, player: BallsPlayer) -> void:
    body.linear_damp = player.default_friction