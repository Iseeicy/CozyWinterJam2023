extends TileRule
class_name SnowRule

#
#   Exports
#

#
#   Virtual Methods
#

func get_tile_id() -> int:
    return ID_SNOW

func enter_tile(_tile_map: TileMap, _position: Vector2i, body: RigidBody2D, _player: BallsPlayer) -> void:
    body.linear_damp = 10

func exit_tile(_tile_map: TileMap, _position: Vector2i, body: RigidBody2D, player: BallsPlayer) -> void:
    body.linear_damp = player.default_friction